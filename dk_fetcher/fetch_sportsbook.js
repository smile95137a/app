const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const DEFAULT_URL =
  'https://sportsbook.draftkings.com/leagues/soccer/world-cup-2026';
const OUT = path.resolve(__dirname, '..', 'assets', 'data', 'dk_board.json');
const RAW_OUT = path.resolve(__dirname, 'response_sportsbook_worldcup.json');

const chromeCandidates = [
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe',
  'C:/Program Files/Microsoft/Edge/Application/msedge.exe',
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
];

function existingBrowserPath() {
  return chromeCandidates.find((candidate) => fs.existsSync(candidate));
}

function parseAmerican(value) {
  if (!value) return null;
  const n = Number(String(value).replace('+', '').trim());
  return Number.isFinite(n) ? n : null;
}

function statusOf(value) {
  switch (String(value || '').toUpperCase()) {
    case 'IN_PROGRESS':
    case 'STARTED':
      return 'live';
    case 'FINAL':
    case 'COMPLETED':
      return 'finalGame';
    case 'CANCELED':
    case 'CANCELLED':
    case 'POSTPONED':
    case 'SUSPENDED':
      return 'canceled';
    default:
      return 'scheduled';
  }
}

function stableFallbackOdds(id) {
  let seed = 0;
  for (const ch of id) seed = (seed + ch.charCodeAt(0) * 31) & 0xffff;
  const homeFavorite = seed % 2 === 0;
  const spread = 0.5;
  return {
    spread,
    homeSpread: homeFavorite ? -spread : spread,
    awaySpread: homeFavorite ? spread : -spread,
    homeSpreadOdds: -110,
    awaySpreadOdds: -110,
    total: 2.5,
    overOdds: -110,
    underOdds: -110,
  };
}

function participant(event, venueRole) {
  return (event.participants || []).find((p) => p.venueRole === venueRole);
}

function selectionOdds(selections, marketId, outcomeType) {
  const selection = selections.find(
    (s) => s.marketId === marketId && s.outcomeType === outcomeType,
  );
  return parseAmerican(selection && selection.displayOdds && selection.displayOdds.american);
}

function buildBoard(data) {
  const markets = data.markets || [];
  const selections = data.selections || [];
  const moneylineByEvent = new Map();

  for (const market of markets) {
    if (market.name === 'Moneyline' && market.eventId) {
      moneylineByEvent.set(market.eventId, market);
    }
  }

  const games = [];
  for (const event of data.events || []) {
    const market = moneylineByEvent.get(event.id);
    const home = participant(event, 'Home');
    const away = participant(event, 'Away');
    if (!market || !home || !away) continue;

    const homeML = selectionOdds(selections, market.id, 'Home');
    const awayML = selectionOdds(selections, market.id, 'Away');
    if (homeML == null || awayML == null) continue;

    const id = `dk-sb-${event.id}`;
    games.push({
      id,
      sport: 'Soccer',
      league: 'World Cup 2026',
      awayTeam: away.name,
      homeTeam: home.name,
      startDate: event.startEventDate,
      status: statusOf(event.status),
      homeML,
      awayML,
      ...stableFallbackOdds(id),
    });
  }

  games.sort((a, b) => String(a.startDate || '').localeCompare(String(b.startDate || '')));
  return {
    generatedAt: new Date().toISOString(),
    source: DEFAULT_URL,
    count: games.length,
    games,
  };
}

async function fetchSportsbookJson(url) {
  const executablePath = existingBrowserPath();
  const launchOptions = { headless: true };
  if (executablePath) launchOptions.executablePath = executablePath;

  const browser = await chromium.launch(launchOptions);
  const page = await browser.newPage({
    viewport: { width: 390, height: 844 },
    userAgent:
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ' +
      '(KHTML, like Gecko) Chrome/125.0 Safari/537.36',
  });

  let captured = null;
  page.on('response', async (response) => {
    const responseUrl = response.url();
    if (
      !captured &&
      responseUrl.includes('/sportscontent/controldata/') &&
      responseUrl.includes('templateVars=209533')
    ) {
      captured = await response.json();
    }
  });

  await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
  for (let i = 0; i < 30 && !captured; i += 1) {
    await page.waitForTimeout(1000);
  }
  await browser.close();

  if (!captured) {
    throw new Error('DraftKings sportsbook markets response was not captured.');
  }
  return captured;
}

async function main() {
  const url = process.argv[2] || DEFAULT_URL;
  console.log(`Opening ${url}`);
  const raw = await fetchSportsbookJson(url);
  const board = buildBoard(raw);

  fs.writeFileSync(RAW_OUT, JSON.stringify(raw, null, 2), 'utf8');
  fs.writeFileSync(OUT, JSON.stringify(board, null, 2), 'utf8');

  console.log(`captured ${raw.events?.length || 0} events`);
  console.log(`wrote ${board.count} board games -> ${path.relative(process.cwd(), OUT)}`);
  console.log(`saved raw response -> ${path.relative(process.cwd(), RAW_OUT)}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
