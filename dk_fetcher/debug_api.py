"""
DraftKings public DFS API probe.
These endpoints are publicly accessible (no auth needed).
VPN optional — these work globally.
Usage: python debug_api.py
"""
import json, sys
try:
    import requests
except ImportError:
    sys.exit("pip install requests")

SESSION = requests.Session()
SESSION.headers.update({
    "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) "
                  "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/15E148 Safari/604.1",
    "Accept": "application/json",
    "Accept-Language": "en-US,en;q=0.9",
})

ENDPOINTS = [
    # ── All sports offered by DraftKings DFS ──
    ("sports_list",
     "https://api.draftkings.com/sites/US-DK/sports/v1/sports",
     {}),

    # ── Lobby contests (includes current draft groups / slates) ──
    ("lobby_all",
     "https://www.draftkings.com/lobby/getcontests",
     {}),

    # ── Sport-specific lobby ──
    ("lobby_nfl",
     "https://www.draftkings.com/lobby/getcontests",
     {"sport": "NFL"}),

    ("lobby_nba",
     "https://www.draftkings.com/lobby/getcontests",
     {"sport": "NBA"}),

    ("lobby_mlb",
     "https://www.draftkings.com/lobby/getcontests",
     {"sport": "MLB"}),

    ("lobby_soccer",
     "https://www.draftkings.com/lobby/getcontests",
     {"sport": "SOC"}),
]

def probe(name, url, params):
    print(f"\n{'='*60}")
    print(f"[{name}]  {url}")
    try:
        r = SESSION.get(url, params=params, timeout=15, allow_redirects=True)
        print(f"  status : {r.status_code}")
        print(f"  size   : {len(r.content)} bytes")
        if r.status_code == 200 and r.headers.get("content-type", "").startswith("application/json"):
            data = r.json()
            top_keys = list(data.keys()) if isinstance(data, dict) else f"[list len={len(data)}]"
            print(f"  keys   : {top_keys}")
            out = f"response_{name}.json"
            with open(out, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"  saved  : {out}  ✓")
        elif r.status_code == 200:
            # Try parse anyway
            try:
                data = r.json()
                top_keys = list(data.keys()) if isinstance(data, dict) else f"[list len={len(data)}]"
                print(f"  keys   : {top_keys}")
                out = f"response_{name}.json"
                with open(out, "w", encoding="utf-8") as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)
                print(f"  saved  : {out}  ✓")
            except Exception:
                print(f"  not JSON — content-type: {r.headers.get('content-type','?')}")
                print(f"  body   : {r.text[:150]}")
        else:
            print(f"  body   : {r.text[:150]}")
    except Exception as e:
        print(f"  FAILED : {e}")

if __name__ == "__main__":
    print("DraftKings public DFS API probe")
    print("No VPN required — these are globally accessible\n")
    for name, url, params in ENDPOINTS:
        probe(name, url, params)
    print("\n\nDone. Paste the sports_list and any lobby_* JSON that has data.")
