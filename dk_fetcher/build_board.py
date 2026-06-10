"""
Extract a clean, display-ready betting board from the saved DraftKings
lobby responses, with full team names + deterministic realistic odds.
Output -> ../assets/data/dk_board.json   (bundled into the Flutter app)

Run:  py build_board.py
"""
import json
import os
import hashlib
from datetime import datetime

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "..", "assets", "data", "dk_board.json")

SPORTS = ["mlb", "nba", "nfl", "soccer"]

# Typical total (over/under) baselines per sport
TOTAL_BASE = {"MLB": 8.5, "NBA": 224.5, "NFL": 44.5, "SOC": 2.5}
SPREAD_STEP = {"MLB": 1.5, "NBA": 1.0, "NFL": 0.5, "SOC": 0.5}


def seed(game_id):
    """Stable pseudo-random in [0,1) from the game id."""
    h = hashlib.md5(str(game_id).encode()).hexdigest()
    return int(h[:8], 16) / 0xFFFFFFFF


def american_from_prob(p):
    """Convert win probability to American odds with a small vig."""
    p = min(max(p, 0.05), 0.95)
    if p >= 0.5:
        return -round((p / (1 - p)) * 100 / 5) * 5
    return round(((1 - p) / p) * 100 / 5) * 5


def build_odds(game_id, sport):
    r = seed(game_id)
    r2 = seed(str(game_id) + "x")
    # home win probability 0.35..0.65
    home_p = 0.35 + r * 0.30
    away_p = 1 - home_p
    home_ml = american_from_prob(home_p)
    away_ml = american_from_prob(away_p)
    home_fav = home_p >= away_p

    step = SPREAD_STEP.get(sport, 1.0)
    if sport == "MLB":
        margin = 1.5  # baseball run line is fixed
    else:
        # at least one step, scaled by how lopsided the matchup is
        margin = max(step, round((abs(home_p - 0.5) * 14) / step) * step)

    home_spread = -margin if home_fav else margin
    away_spread = margin if home_fav else -margin

    base = TOTAL_BASE.get(sport, 5.5)
    total = base + (round((r2 - 0.5) * 4 / step) * step)

    return {
        "homeML": home_ml,
        "awayML": away_ml,
        "spread": margin,
        "homeSpread": home_spread + 0.0,
        "awaySpread": away_spread + 0.0,
        "homeSpreadOdds": -110,
        "awaySpreadOdds": -110,
        "total": round(total, 1),
        "overOdds": -110,
        "underOdds": -115,
    }


def norm_status(s):
    s = (s or "").lower()
    if s in ("in-game", "in progress", "live"):
        return "live"
    if s in ("final", "final/ot", "complete", "completed"):
        return "finalGame"
    if s in ("cancelled", "canceled", "postponed", "suspended"):
        return "canceled"
    return "scheduled"


def team_name(city, name):
    city = (city or "").strip()
    name = (name or "").strip()
    return f"{city} {name}".strip() if city else name


def main():
    games = []
    seen = set()

    for sp in SPORTS:
        path = os.path.join(HERE, f"response_lobby_{sp}.json")
        if not os.path.exists(path):
            print(f"skip {sp}: no file")
            continue
        data = json.load(open(path, encoding="utf-8"))
        sport_code = (data.get("SelectedSport") or sp).upper()

        for gset in data.get("GameSets", []):
            for c in gset.get("Competitions", []):
                gid = c.get("GameId")
                if not gid or gid in seen:
                    continue
                home = team_name(c.get("HomeTeamCity"), c.get("HomeTeamName"))
                away = team_name(c.get("AwayTeamCity"), c.get("AwayTeamName"))
                if not home or not away:
                    continue
                seen.add(gid)

                odds = build_odds(gid, sport_code)
                games.append({
                    "id": f"dk-{gid}",
                    "sport": sport_code,
                    "league": sport_code,
                    "awayTeam": away,
                    "homeTeam": home,
                    "startDate": c.get("StartDate"),
                    "status": norm_status(c.get("Status")),
                    "location": c.get("Location") or "",
                    **odds,
                })

    games.sort(key=lambda g: (g["sport"], g["startDate"] or ""))

    out = {
        "generatedAt": datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
        "count": len(games),
        "games": games,
    }
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as f:
        json.dump(out, f, indent=2, ensure_ascii=False)

    by_sport = {}
    for g in games:
        by_sport[g["sport"]] = by_sport.get(g["sport"], 0) + 1
    print(f"wrote {len(games)} games -> {os.path.relpath(OUT, HERE)}")
    for s, n in sorted(by_sport.items()):
        print(f"  {s:5} {n}")


if __name__ == "__main__":
    main()
