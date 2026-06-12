import 'package:flutter/material.dart';

/// Displays a team logo by loading from ESPN CDN.
/// Falls back to a colored circle with initials if unavailable.
class TeamLogo extends StatelessWidget {
  final String teamName;
  final double size;

  const TeamLogo({super.key, required this.teamName, required this.size});

  // ── ESPN CDN URL lookup ─────────────────────────────
  static String? logoUrl(String teamName) {
    final n = teamName.toLowerCase();

    // ── NBA ──────────────────────────────────────────
    if (n.contains('knick'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/nyk.png';
    if (n.contains('cavalier') || n.contains('cle cavalier'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/cle.png';
    if (n.contains('spurs') &&
        !n.contains('soccer') &&
        !n.contains('tottenham'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/sa.png';
    if (n.contains('thunder') && !n.contains('nfl'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/okc.png';
    if (n.contains('laker'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/lal.png';
    if (n.contains('celtic'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/bos.png';
    if (n.contains('heat') && !n.contains('mlb'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/mia.png';
    if (n.contains('warrior'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/gs.png';
    if (n.contains('nugget'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/den.png';
    if (n.contains('buck') && !n.contains('mlb'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/mil.png';
    if (n.contains('hawk') && !n.contains('nhl'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/atl.png';
    if (n.contains('maverick'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/dal.png';
    if (n.contains('sun') && n.contains('phoenix'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/phx.png';
    if (n.contains('clipper'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/lac.png';
    if (n.contains('76er') || n.contains('sixer'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/phi.png';
    if (n.contains('raptor'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/tor.png';
    if (n.contains('timberwolf'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/min.png';
    if (n.contains('pelican'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/no.png';
    if (n.contains('trail blazer') || n.contains('blazer'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/por.png';
    if (n.contains('jazz'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/utah.png';
    if (n.contains('magic') && !n.contains('nfl'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/orl.png';
    if (n.contains('rocket') && !n.contains('nfl'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/hou.png';
    if (n.contains('pacer'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/ind.png';
    if (n.contains('grizzl'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/mem.png';
    if (n.contains('hornet'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/cha.png';
    if (n.contains('piston'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/det.png';
    if (n.contains('wizard'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/wsh.png';
    if (n.contains('net') && n.contains('brooklyn'))
      return 'https://a.espncdn.com/i/teamlogos/nba/500/bkn.png';

    // ── MLB ──────────────────────────────────────────
    if (n.contains('rockies') || (n.contains('col') && n.contains('rock')))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/col.png';
    if (n.contains('dodger'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/lad.png';
    if (n.contains('yankee'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/nyy.png';
    if (n.contains('royal') && !n.contains('nba'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/kc.png';
    if (n.contains('red sox'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/bos.png';
    if (n.contains('cub') && !n.contains('nba'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/chc.png';
    if (n.contains('white sox'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/chw.png';
    if (n.contains('brewer'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/mil.png';
    if (n.contains('padre'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/sd.png';
    if (n.contains('astro'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/hou.png';
    if (n.contains('mariner'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/sea.png';
    if (n.contains('ranger') && !n.contains('nfl'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/tex.png';
    if (n.contains('angel'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/laa.png';
    if (n.contains('phillie'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/phi.png';
    if (n.contains('pirate'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/pit.png';
    if (n.contains('tiger') && !n.contains('lsu'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/det.png';
    if (n.contains('twin'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/min.png';
    if (n.contains('blue jay'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/tor.png';
    if (n.contains('oriole'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/bal.png';
    if (n.contains('met') && n.contains('ny'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/nym.png';
    if (n.contains('giant') &&
        (n.contains('sf') || n.contains('san francisco')))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/sf.png';
    if (n.contains('cardinal') && n.contains('stl'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/stl.png';
    if (n.contains('indian') || n.contains('guardian'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/cle.png';
    if (n.contains('brave') && n.contains('atlanta'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/atl.png';
    if (n.contains('marlins') || n.contains('miami') && n.contains('mlb'))
      return 'https://a.espncdn.com/i/teamlogos/mlb/500/mia.png';

    // ── NFL ──────────────────────────────────────────
    if (n.contains('chief'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/kc.png';
    if (n.contains('patriot'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/ne.png';
    if (n.contains('cowboy'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/dal.png';
    if (n.contains('eagle') && n.contains('philadelphia'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/phi.png';
    if (n.contains('49er') || n.contains('forty niner'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/sf.png';
    if (n.contains('packer'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/gb.png';
    if (n.contains('raven'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/bal.png';
    if (n.contains('bear') && n.contains('chicago'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/chi.png';
    if (n.contains('bronco'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/den.png';
    if (n.contains('giant') && n.contains('new york'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/nyg.png';
    if (n.contains('jet') && n.contains('new york'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/nyj.png';
    if (n.contains('steeler'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/pit.png';
    if (n.contains('seahawk'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/sea.png';
    if (n.contains('charger'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/lac.png';
    if (n.contains('raider'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/lv.png';
    if (n.contains('titan'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/ten.png';
    if (n.contains('colt') && n.contains('indianapolis'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/ind.png';
    if (n.contains('bill') && n.contains('buffalo'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/buf.png';
    if (n.contains('dolphin'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/mia.png';
    if (n.contains('lion') && n.contains('detroit'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/det.png';
    if (n.contains('buccaneer') || n.contains('buccaneers'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/tb.png';
    if (n.contains('saint') && n.contains('new orleans'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/no.png';
    if (n.contains('falcon') && n.contains('atlanta'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/atl.png';
    if (n.contains('panther'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/car.png';
    if (n.contains('commander'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/wsh.png';
    if (n.contains('cardinal') && n.contains('arizona'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/ari.png';
    if (n.contains('ram') && n.contains('los angeles'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/lar.png';
    if (n.contains('viking'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/min.png';
    if (n.contains('texan') && n.contains('houston'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/hou.png';
    if (n.contains('jaguars') || n.contains('jaguar'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/jax.png';
    if (n.contains('bengal'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/cin.png';
    if (n.contains('brown') && n.contains('cleveland'))
      return 'https://a.espncdn.com/i/teamlogos/nfl/500/cle.png';

    // ── Soccer / Premier League ──────────────────────
    if (n.contains('crystal palace'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/384.png';
    if (n.contains('arsenal'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/359.png';
    if (n.contains('chelsea'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/363.png';
    if (n.contains('liverpool'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/364.png';
    if (n.contains('manchester city') || (n.contains('man city')))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/382.png';
    if (n.contains('manchester united') || n.contains('man utd'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/360.png';
    if (n.contains('tottenham') ||
        (n.contains('spurs') && n.contains('london')))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/367.png';
    if (n.contains('aston villa'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/362.png';
    if (n.contains('everton'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/368.png';
    if (n.contains('west ham'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/371.png';
    if (n.contains('newcastle'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/361.png';
    if (n.contains('brighton'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/331.png';
    if (n.contains('wolves') || n.contains('wolverhampton'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/380.png';
    if (n.contains('brentford'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/337.png';
    if (n.contains('fulham'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/370.png';
    if (n.contains('nottingham'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/393.png';
    if (n.contains('bournemouth'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/349.png';
    if (n.contains('leicester'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/375.png';
    if (n.contains('vallecano') || n.contains('vallec'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/101.png';
    if (n.contains('real madrid'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/86.png';
    if (n.contains('barcelona') || n.contains('barca'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/83.png';
    if (n.contains('atletico'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/1068.png';
    if (n.contains('haiti'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/110.png';
    if (n.contains('scotland'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/104.png';
    if (n.contains('usa') || n.contains('united states'))
      return 'https://a.espncdn.com/i/teamlogos/soccer/500/356.png';

    return null;
  }

  // ── Team primary color fallback ─────────────────────
  static Color teamColor(String name) {
    final n = name.toLowerCase();
    if (n.contains('knick')) return const Color(0xFF0033A0);
    if (n.contains('cavalier')) return const Color(0xFF6F263D);
    if (n.contains('yankee')) return const Color(0xFF132448);
    if (n.contains('dodger')) return const Color(0xFF005A9C);
    if (n.contains('rockies') || (n.contains('rock') && n.contains('col')))
      return const Color(0xFF33006F);
    if (n.contains('spurs') && !n.contains('tottenham'))
      return const Color(0xFF8A8D8F);
    if (n.contains('thunder')) return const Color(0xFF007DC5);
    if (n.contains('laker')) return const Color(0xFF552583);
    if (n.contains('celtic')) return const Color(0xFF007A33);
    if (n.contains('heat')) return const Color(0xFF98002E);
    if (n.contains('warrior')) return const Color(0xFF1D428A);
    if (n.contains('palace')) return const Color(0xFF1B458F);
    if (n.contains('royal') && !n.contains('nba'))
      return const Color(0xFF174885);
    if (n.contains('chief')) return const Color(0xFFE31837);
    if (n.contains('patriot')) return const Color(0xFF002244);
    if (n.contains('packer')) return const Color(0xFF203731);
    if (n.contains('49er') || n.contains('forty'))
      return const Color(0xFFAA0000);
    if (n.contains('liverpool')) return const Color(0xFFCC0000);
    if (n.contains('arsenal')) return const Color(0xFFDB0007);
    if (n.contains('chelsea')) return const Color(0xFF034694);
    if (n.contains('man city') || n.contains('manchester city'))
      return const Color(0xFF6CABDD);
    if (n.contains('nugget')) return const Color(0xFF0E2240);
    if (n.contains('buck')) return const Color(0xFF00471B);
    if (n.contains('maverick')) return const Color(0xFF00538C);
    return const Color(0xFF2A2A2A);
  }

  static String _abbr(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      final last = words.last;
      return last.substring(0, last.length.clamp(0, 2)).toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final url = logoUrl(teamName);
    final color = teamColor(teamName);
    final abbr = _abbr(teamName);

    return SizedBox(
      width: size,
      height: size,
      child: url != null
          ? Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.contain,
              // ESPN CDN blocks Dart's default UA on Android/iOS.
              headers: const {
                'User-Agent':
                    'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 '
                    '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
              },
              errorBuilder: (_, __, ___) =>
                  _Fallback(color: color, abbr: abbr, size: size),
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : _Fallback(color: color, abbr: abbr, size: size),
            )
          : _Fallback(color: color, abbr: abbr, size: size),
    );
  }
}

class _Fallback extends StatelessWidget {
  final Color color;
  final String abbr;
  final double size;
  const _Fallback(
      {required this.color, required this.abbr, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          abbr,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: size * 0.34,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
