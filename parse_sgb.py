from pathlib import Path
import re
import json
from typing import Dict, List

# ---------- Core parsing ----------

def gb_to_rgb(r: int, g: int, b: int) -> str:
    """Convert 0–31 (GB) to #RRGGBB."""
    return "#{:02X}{:02X}{:02X}".format(r * 255 // 31, g * 255 // 31, b * 255 // 31)

def parse_super_palettes(pal_file: Path) -> Dict[str, List[str]]:
    """
    Parse an SGB palette table like the one you pasted (SuperPalettes).
    Returns { 'PAL_ROUTE': ['#FFFFF7', '#...'], ... }  (4 colors, light->dark, in file order)
    """
    text = pal_file.read_text(encoding="utf-8", errors="ignore")
    # Lines are like: RGB 31,29,31, 21,28,11, 20,26,31, 03,02,02 ; PAL_ROUTE
    pat = re.compile(
        r"RGB\s+(\d+),\s*(\d+),\s*(\d+)\s*,\s*"
        r"(\d+),\s*(\d+),\s*(\d+)\s*,\s*"
        r"(\d+),\s*(\d+),\s*(\d+)\s*,\s*"
        r"(\d+),\s*(\d+),\s*(\d+)\s*;\s*(PAL_[A-Z0-9_]+)",
        re.I,
    )
    out: Dict[str, List[str]] = {}
    for m in pat.finditer(text):
        c = [int(x) for x in m.groups()[:-1]]
        name = m.group(len(m.groups()))
        cols = [gb_to_rgb(*c[i:i+3]) for i in (0,3,6,9)]
        out[name] = cols
    if not out:
        raise SystemExit(f"Could not parse any SGB palettes from {pal_file}")
    return out

# ---------- Heuristic map->PAL_* assignment ----------

_CITY_KEYS = [
    "PALLET", "VIRIDIAN", "PEWTER", "CERULEAN", "LAVENDER",
    "VERMILION", "CELADON", "FUCHSIA", "CINNABAR", "SAFFRON", "INDIGO"
]

def _city_of(map_const: str) -> str | None:
    up = map_const.upper()
    for city in _CITY_KEYS:
        if city in up:
            return city
    return None

def infer_palette_name_for_map(map_const: str) -> str:
    """
    Best-effort mapping for pokered-style names:
      ROUTE_*            -> PAL_ROUTE
      *CAVE*, *TUNNEL*, *SEAFOAM*, *DUNGEON* -> PAL_CAVE
      *POKECENTER*, *POKEMART*, *GYM*, *MANSION*, *SILPH*, *LAVENDER_TOWER* etc.
                           -> corresponding city PAL_* if the name contains a city; else PAL_ROUTE
      *CITY/TOWN/ISLAND/PLATEAU* with city name -> PAL_<CITY>
      otherwise fall back to PAL_ROUTE
    """
    name = map_const.upper()

    if name.startswith("ROUTE_"):
        return "PAL_ROUTE"

    cave_words = ("CAVE", "TUNNEL", "SEAFOAM", "ROCK_TUNNEL", "VICTORY_ROAD", "UNKNOWN_DUNGEON", "MT_", "MOUNTAIN")
    if any(w in name for w in cave_words):
        return "PAL_CAVE"

    # City/town/area surfaces
    city = _city_of(name)
    if city and any(k in name for k in ("CITY", "TOWN", "ISLAND", "PLATEAU")):
        return f"PAL_{city}"
    
        
    if name == "MR_FUJIS_HOUSE":
        return "PAL_LAVENDER"
    
    if name == "MR_PSYCHICS_HOUSE":
        return "PAL_SAFFRON"
    
    if any(k in name for k in ("POKEMON_TOWER", "AGATHAS_ROOM")):
        return "PAL_GRAYMON"
    
    if name == "BRUNOS_ROOM":
        return "PAL_CAVE"
    
    if name == "LORELEIS_ROOM":
        return "PAL_ROUTE"
    
    if "POKEMON_MANSION" in name:
        return "PAL_CINNABAR"

    if "ROCKET_HIDEOUT" in name:
        return "PAL_CELADON"

    if any(k in name for k in ("SILPH", "DOJO")):
        return "PAL_SAFFRON"

    if "SS_ANNE" in name:
        return "PAL_VERMILION"

    # Common interiors – use the host city's palette if the name includes it
    interior_words = ("POKECENTER", "POKEMART", "GYM", "MANSION", "SILPH", "GATE", "COPYCAT", "DOJO", "BIKE", "FAN_CLUB", "GAME_CORNER", "ROCKET", "HOUSE", "MANSION", "LAB")
    if any(w in name for w in interior_words):
        if city:
            return f"PAL_{city}"
        if name == "WARDENS_HOUSE":
            return "PAL_FUCHSIA"
        # If no city in the name, many interiors still “feel” ROUTE-ish on SGB
        return "PAL_ROUTE"


    # Safari zones feel like route/grass on SGB
    if "SAFARI" in name:
        return "PAL_ROUTE"

    # Water routes (e.g., 19–21) were still under route palette on SGB
    if "SEA" in name or "FISH" in name or "SURF" in name:
        return "PAL_ROUTE"

    # Fallback
    return "PAL_ROUTE"

def build_map_to_palette(root: Path, pal_file: Path, overrides_json: Path | None = None) -> Dict[str, List[str]]:
    """
    Create a dict { MAP_CONST: [#hex,#hex,#hex,#hex] } using:
      - parsed SuperPalettes from pal_file
      - heuristic per-map assignment from MAP_CONST
      - optional overrides JSON { MAP_CONST: "PAL_*" or [#hex...4] }
    """
    pals = parse_super_palettes(pal_file)
    mapping: Dict[str, List[str]] = {}

    # If you have a canonical list of maps, scan constants/map_constants.asm to enumerate them:
    maps_list: list[str] = []
    consts = root / "constants" / "map_constants.asm"
    if consts.exists():
        txt = consts.read_text(encoding="utf-8", errors="ignore")
        for m in re.finditer(r"^\s*map_const\s+([A-Z0-9_]+)\s*,", txt, re.M | re.I):
            maps_list.append(m.group(1))

    # If that fails, we can still fill on-demand later; but try to prefill:
    for mname in maps_list:
        pal_name = infer_palette_name_for_map(mname)
        if pal_name in pals:
            mapping[mname] = pals[pal_name]

    # Apply optional overrides
    if overrides_json and overrides_json.exists():
        ov = json.loads(overrides_json.read_text(encoding="utf-8"))
        for k, v in ov.items():
            if isinstance(v, str) and v.startswith("PAL_"):
                if v in pals:
                    mapping[k] = pals[v]
            elif isinstance(v, list) and len(v) == 4:
                mapping[k] = v  # already #hex strings

    return mapping
