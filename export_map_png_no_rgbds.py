#!/usr/bin/env python3
"""
export_map_png_no_rgbds.py

Render Pokémon Red/Blue .blk maps to PNG (no RGBDS required), optionally
applying per-map palettes and overlaying NPCs from objects files.

This version fixes two issues users often hit:
- Sprites coming from sprite *sheets* (e.g., 16x32 or 48x16) are now CROPPED to
  a single 16x16 frame by default (top-left), instead of being resized/squashed.
- Optional --sprite-frame lets you choose a specific frame from a sheet laid
  out either horizontally or vertically (auto-detected).
"""

from __future__ import annotations

import argparse
import json
import os
import re
from pathlib import Path
from typing import Dict, List, Tuple, Optional

from PIL import Image, ImageDraw

from parse_sgb import build_map_to_palette


def die(msg: str) -> None:
    raise SystemExit(msg)


def hex_to_rgb(h: str) -> Tuple[int, int, int]:
    h = h.strip().lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    if len(h) != 6:
        die(f"Bad hex color: {h}")
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))  # type: ignore[return-value]


def ensure_rgba(img: Image.Image) -> Image.Image:
    return img if img.mode == "RGBA" else img.convert("RGBA")


def preset_palette(name: str) -> List[Tuple[int, int, int]]:
    n = name.lower()
    if n == "morn":
        return [
            (0xFF, 0xEF, 0xFF),  # #FFEFFF
            (0xAD, 0xE7, 0x5A),  # #ADE75A
            (0xA5, 0xD6, 0xFF),  # #A5D6FF
            (0x18, 0x10, 0x10),  # #181010
        ]
    die(f"Unknown palette preset: {name}")


def recolor_background_rgba(img_rgba: Image.Image, pal_rgb: list[tuple[int,int,int]]) -> Image.Image:
    """
    Map the 4 DMG greys in the background image to the 4 palette colors.
    pal_rgb must be [lightest, midlight, middark, darkest].
    """

    # Ensure we’re RGBA
    img_rgba = img_rgba.convert("RGBA")
    w, h = img_rgba.size

    # Convert to greyscale to identify the 4 unique levels
    lum = img_rgba.convert("L")
    levels = sorted(set(lum.getdata()))
    if len(levels) > 4:
        # pick 4 spread values if PNG has stray levels
        quantiles = [0, len(levels)//3, 2*len(levels)//3, -1]
        levels = [levels[q] for q in quantiles]
    while len(levels) < 4:
        levels.append(255)
    levels = sorted(levels)

    # Map greys → palette entries (darkest grey → darkest palette color, etc.)
    shade_to_color = {}
    for i, lvl in enumerate(levels):
        # levels[0] = darkest grey, levels[-1] = lightest
        pal_index = 3 - i   # darkest grey → pal_rgb[3], lightest grey → pal_rgb[0]
        shade_to_color[lvl] = (*pal_rgb[pal_index], 255)

    # Apply mapping pixel by pixel
    out = Image.new("RGBA", (w, h))
    src_px = img_rgba.load()
    lum_px = lum.load()
    out_px = out.load()

    for y in range(h):
        for x in range(w):
            r, g, b, a = src_px[x, y]
            if a == 0:
                out_px[x, y] = (0, 0, 0, 0)
            else:
                l = lum_px[x, y]
                # snap to nearest known level if not exact
                nearest = min(levels, key=lambda lv: abs(lv - l))
                out_px[x, y] = shade_to_color[nearest]
    return out


def recolor_sprite_rgba(
    sprite_rgba: Image.Image,
    pal_rgb: list[tuple[int, int, int]],
    keep_white: bool = True,
    target_grey: int = 170,
    tol: int = 6,
    flip_sprite: bool = False,
) -> Image.Image:
    """
    Recolor GB sprites using 4-color palette (light→dark).

    - Detects up to 4 greys in the sprite, maps darkest→pal[3] … lightest→pal[0].
    - If keep_grey_as_white=True, any pixel whose luminance is ~target_grey (±tol)
      will be forced to pure white (255,255,255).
    """
    sprite_rgba = ensure_rgba(sprite_rgba)
    w, h = sprite_rgba.size

    # Canonical DMG shades (dark→light when indexed via idx 0..3)
    CANON = [0, 85, 170, 255]

    Limg = sprite_rgba.convert("L")
    pal_rgba = [(*c, 255) for c in pal_rgb]

    src = sprite_rgba.load()
    L   = Limg.load()
    out = Image.new("RGBA", (w, h))
    O   = out.load()

    for y in range(h):
        for x in range(w):
            r, g, b, a = src[x, y]
            if a == 0:
                O[x, y] = (0, 0, 0, 0)
                continue

            l = L[x, y]
            # SNAP TO CANONICAL, not to detected levels
            nearest = min(CANON, key=lambda lv: abs(lv - l))
            
            # preserve the ~170 shade as pure white if requested
            if keep_white and abs(nearest - target_grey) <= tol:

                O[x, y] = (255, 255, 255, a)
                continue

            # (optional) treat ~85 as darkest so hair goes to pal[3]
            # if promote_85_to_darkest and abs(nearest - 85) <= tol:
            #     O[x, y] = pal_rgba[3]
            #     continue

            idx = CANON.index(nearest)      # 0..3 = dark→light
            O[x, y] = pal_rgba[3 - idx]     # map to pal (light→dark)


            if flip_sprite:
                if idx == 1:
                    idx = 2
                elif idx == 2:
                    idx = 2
            O[x, y] = pal_rgba[3 - idx]
    return out




HEADER_RE = re.compile(r"map_header\s+\w+\s*,\s*(\w+)\s*,\s*(\w+)\s*,", re.I)
PAT_MAP_CONST = re.compile(r"^\s*map_const\s+{name}\s*,\s*(\d+)\s*,\s*(\d+)\b", re.I | re.M)
PAT_EQU_WH = re.compile(r"DEF\s+{name}_WIDTH\s+EQU\s+(\d+).*?DEF\s+{name}_HEIGHT\s+EQU\s+(\d+)", re.I | re.S)
PAT_EQU_HW = re.compile(r"DEF\s+{name}_HEIGHT\s+EQU\s+(\d+).*?DEF\s+{name}_WIDTH\s+EQU\s+(\d+)", re.I | re.S)

OBJ_LINE = re.compile(
    r"^\s*(?:object_event|itemball_event)\s+(\d+)\s*,\s*(\d+)"
    r"(?:\s*,\s*([A-Z0-9_]+))?"           # sprite token (or None for itemball_event)
    r"(?:\s*,\s*([A-Z_]+))?"              # movement (STAY/WALK/…)
    r"(?:\s*,\s*([A-Z_]+))?",             # facing or range (DOWN/LEFT_RIGHT/…)
    re.I
)


def parse_header(pokered_root: Path, blk_path: Path) -> Tuple[str, str]:
    name = blk_path.stem
    header = pokered_root / "data" / "maps" / "headers" / f"{name}.asm"
    if not header.exists():
        die(f"Couldn't find header for {name}: {header}")
    text = header.read_text(encoding="utf-8", errors="ignore")
    m = HEADER_RE.search(text)
    if not m:
        die(f"Couldn't parse map_header in {header}")
    map_const = m.group(1)
    tileset_name = m.group(2)
    return map_const, tileset_name


def parse_map_dimensions(root: Path, map_const: str) -> Tuple[int, int]:
    candidates = [
        root / "constants" / "map_constants.asm",
        root / "constants" / "map_dimensions.asm",
        root / "constants" / "map_data_constants.asm",
    ]
    for path in candidates:
        if not path.exists():
            continue
        txt = path.read_text(encoding="utf-8", errors="ignore")
        m = re.compile(PAT_MAP_CONST.pattern.format(name=re.escape(map_const)), re.I | re.M).search(txt)
        if m:
            w, h = int(m.group(1)), int(m.group(2))
            return w, h
        m = re.compile(PAT_EQU_WH.pattern.format(name=re.escape(map_const)), re.I | re.S).search(txt)
        if m:
            w, h = int(m.group(1)), int(m.group(2))
            return w, h
        m = re.compile(PAT_EQU_HW.pattern.format(name=re.escape(map_const)), re.I | re.S).search(txt)
        if m:
            h, w = int(m.group(1)), int(m.group(2))
            return w, h
    die(f"Could not find dimensions for {map_const}. Use --size WxH to override.")


def slice_tiles_from_png(tileset_png: Path) -> List[Image.Image]:
    if not tileset_png.exists():
        die(f"Missing tileset PNG: {tileset_png}")
    img = Image.open(tileset_png).convert("RGBA")
    W, H = img.size
    if W % 8 or H % 8:
        die(f"Tileset PNG size not multiple of 8: {W}x{H}")
    tiles = []
    for ty in range(H // 8):
        for tx in range(W // 8):
            tile = img.crop((tx * 8, ty * 8, tx * 8 + 8, ty * 8 + 8))
            tiles.append(tile)
    return tiles


def read_bst_blocks(path: Path) -> List[List[int]]:
    raw = path.read_bytes()
    if len(raw) % 16 != 0:
        die(f"{path} size {len(raw)} not multiple of 16 (4x4 tiles per block).")
    blocks: List[List[int]] = []
    for off in range(0, len(raw), 16):
        blocks.append(list(raw[off:off + 16]))
    return blocks


def compose_map(blk: bytes, blocks_w: int, blocks_h: int, blocks: List[List[int]], tiles: List[Image.Image]) -> Image.Image:
    out = Image.new("RGBA", (blocks_w * 32, blocks_h * 32))
    for i, b in enumerate(blk):
        bx, by = i % blocks_w, i // blocks_w
        block = blocks[b]
        for ty in range(4):
            for tx in range(4):
                tile_idx = block[ty * 4 + tx]
                if tile_idx >= len(tiles):
                    die(f"Tile index {tile_idx} out of range (tiles={len(tiles)})")
                out.alpha_composite(tiles[tile_idx], (bx * 32 + tx * 8, by * 32 + ty * 8))
    return out


def find_objects_asm(root: Path, map_name_pascal: str) -> Optional[Path]:
    p = root / "data" / "maps" / "objects" / f"{map_name_pascal}.asm"
    return p if p.exists() else None


def parse_object_events(path: Path, order: str = 'xy') -> List[Dict[str, object]]:
    evts: List[Dict[str, object]] = []
    for line in path.read_text(encoding="utf-8", errors="ignore").splitlines():
        m = OBJ_LINE.match(line)
        if m:
            if order == 'xy':
                y = int(m.group(1))
                x = int(m.group(2))
            else:
                x = int(m.group(1))
                y = int(m.group(2))
            sprite = m.group(3) if m.group(3) else "ITEMBALL"

            evts.append({"x": x, "y": y, "sprite": sprite, "movement": m.group(4), "facing": m.group(5)})
    return evts




def draw_marker(img_rgba: Image.Image, x_px: int, y_px: int, label: Optional[str] = None) -> None:
    marker = Image.new("RGBA", (16, 16), (255, 0, 255, 180))
    d = ImageDraw.Draw(marker)
    d.rectangle([0, 0, 15, 15], outline=(0, 0, 0, 200))
    img_rgba.alpha_composite(marker, (x_px, y_px))


def crop_frame_16x16(spr: Image.Image, frame_index: int = 0) -> Image.Image:
    """Return a 16x16 crop from a sprite sheet.
    If spr is already 16x16 → return as-is.
    If width is a multiple of 16 and height == 16 → horizontal strip.
    If height is a multiple of 16 and width == 16 → vertical strip.
    Otherwise → top-left 16x16.
    """
    w, h = spr.size
    if (w, h) == (16, 16):
        return spr

    if h == 16 and w >= 16 and w % 16 == 0:
        # horizontal strip
        cols = w // 16
        i = max(0, min(frame_index, cols - 1))
        x0 = i * 16
        return spr.crop((x0, 0, x0 + 16, 16))

    if w == 16 and h >= 16 and h % 16 == 0:
        # vertical strip
        rows = h // 16
        i = max(0, min(frame_index, rows - 1))
        y0 = i * 16
        return spr.crop((0, y0, 16, y0 + 16))

    # generic spritesheet → top-left crop
    return spr.crop((0, 0, 16, 16))

def make_bg_transparent(img_rgba: Image.Image, fuzz:int=8)->Image.Image:
    img=img_rgba.convert("RGBA")
    bg=img.getpixel((0,0))[:3]
    def close(a,b): return abs(a-b)<=fuzz
    px=img.load(); w,h=img.size
    for y in range(h):
        for x in range(w):
            r,g,b,a=px[x,y]
            if a==0: continue
            if close(r,bg[0]) and close(g,bg[1]) and close(b,bg[2]):
                px[x,y]=(r,g,b,0)
    return img

def load_sprite_png(root: Path, mapping: Dict[str, str], sprite_token: str, frame_index: int = 0) -> Optional[Image.Image]:
    path = mapping.get(sprite_token)
    if not path:
        return None
    p = Path(path) if Path(path).is_absolute() else (root / path)
    if not p.exists():
        return None
    spr = Image.open(p).convert("RGBA")
    spr = crop_frame_16x16(spr, frame_index)

    # # Make pure white transparent
    # datas = spr.getdata()
    # new_data = []
    # for r, g, b, a in datas:
    #     if (r, g, b) == (255, 255, 255):
    #         new_data.append((255, 255, 255, 0))
    #     else:
    #         new_data.append((r, g, b, a))
    # spr.putdata(new_data)
    spr = make_bg_transparent(spr, 8)

    if spr.size != (16, 16):
        spr = spr.resize((16, 16), Image.NEAREST)
    return spr


def infer_coord_mode(events: List[Dict[str, object]], w_blocks: int, h_blocks: int) -> str:
    if not events:
        return "tiles"
    maxx = max(int(e["x"]) for e in events)
    maxy = max(int(e["y"]) for e in events)
    if maxx <= w_blocks and maxy <= h_blocks:
        return "blocks"
    if maxx <= w_blocks * 2 and maxy <= h_blocks * 2:
        return "metatiles"
    return "tiles"


def parse_offset_arg(arg: str) -> Tuple[int, int]:
    m = re.match(r"\s*(-?\d+)\s*,\s*(-?\d+)\s*$", arg)
    if not m:
        die("--object-offset must be like 'dx,dy' in *tiles* (e.g., 0,0 or 1,-1)")
    return int(m.group(1)), int(m.group(2))

def brighten_rgba(img: Image.Image, percent: float) -> Image.Image:
    """Move RGB toward white by <percent> (0..100). Alpha preserved."""
    if percent <= 0: return img
    p = max(0.0, min(100.0, percent)) / 100.0
    img = img.convert("RGBA")
    px = img.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r,g,b,a = px[x,y]
            if a == 0: 
                continue
            r = int(r + p*(255 - r))
            g = int(g + p*(255 - g))
            b = int(b + p*(255 - b))
            px[x,y] = (r,g,b,a)
    return img

def gamma_rgba(img: Image.Image, gamma: float) -> Image.Image:
    """Apply gamma to RGB (alpha preserved). gamma < 1 brightens."""
    if abs(gamma - 1.0) < 1e-6: return img
    img = img.convert("RGBA")
    lut = [max(0, min(255, int((i/255.0) ** (1.0/gamma) * 255 + 0.5))) for i in range(256)]
    r,g,b,a = img.split()
    r = r.point(lut); g = g.point(lut); b = b.point(lut)
    return Image.merge("RGBA", (r,g,b,a))



def main() -> None:
    ap = argparse.ArgumentParser(description="Export Pokémon R/B maps from .blk to PNG (no RGBDS).")
    ap.add_argument("--pokered", required=True, help="Path to pret/pokered root")
    ap.add_argument("--blk", required=True, help="Path to map .blk (e.g., maps/PalletTown.blk)")
    ap.add_argument("--out", required=True, help="Output PNG path")
    ap.add_argument("--size", help="Override map size as WxH in blocks, e.g., 10x9")

    ap.add_argument("--palette", help="4 comma-separated hex colors (light→dark) for background")
    ap.add_argument("--palette-preset", help="Preset name for background (e.g., 'morn')")
    ap.add_argument("--palette-map", help="JSON file mapping { MAP_CONST: [#hex,#hex,#hex,#hex], _default: [...] }")

    ap.add_argument("--overlay-npcs", action="store_true", help="Overlay NPCs from data/maps/objects/<Map>.asm")
    ap.add_argument("--npc-mode", choices=["markers", "sprites"], default="markers", help="markers or sprites")
    ap.add_argument("--npc-sprite-map", help="JSON mapping { 'SPRITE_LASS': 'gfx/sprites/lass.png', ... }")

    ap.add_argument("--object-coords", choices=["auto", "tiles", "metatiles", "blocks"], default="tiles",
                    help="Units for object_event coords (tiles=8px, metatiles=16px, blocks=32px). Default: tiles")
    ap.add_argument("--object-offset", default="0,0",
                    help="Global offset for NPCs in *tiles*, e.g. 0,0 or 1,-1")

    ap.add_argument("--object-order", choices=["xy","yx"], default="xy",
                    help="Order of object_event coords in your repo: 'xy' (x,y) or 'yx' (y,x). Default: xy")

    ap.add_argument("--sprite-palette", help="4 comma-separated hex colors (light→dark) to recolor sprites")
    ap.add_argument("--sprite-frame", type=int, default=0,
                    help="Frame index to crop from sprite sheets (0-based).")
    ap.add_argument("--sprite-palette-map",
                help="JSON { SPRITE_TOKEN: [#hex,#hex,#hex,#hex], ... }")
    
    ap.add_argument("--sprite-brighten", type=float, default=0.0,
                help="Brighten sprites by this percent (e.g., 25 = +25%).")
    ap.add_argument("--sprite-gamma", type=float, default=1.0,
                    help="Gamma for sprites only (1.0 = none; 0.9 = brighter, 1.1 = darker).")
    ap.add_argument("--use-sgb", action="store_true",
                    help="Use Super Game Boy palettes (parsed from sgb_palettes.asm)")
    ap.add_argument("--sgb-pal-file", default="data/sgb/sgb_palettes.asm",
                    help="Path to sgb_palettes.asm (the file you pasted)")
    ap.add_argument("--sgb-overrides", help="JSON { MAP_CONST: 'PAL_*' or [#hex,#hex,#hex,#hex] } for edge cases")



    args = ap.parse_args()

    root = Path(args.pokered).resolve()
    blk_path = Path(args.blk)
    if not blk_path.is_absolute():
        blk_path = (root / args.blk).resolve()
    if not blk_path.exists():
        die(f"Missing .blk: {blk_path}")

    map_const, tileset = parse_header(root, blk_path)
    tileset_lower = tileset.lower()

    sprite_pal_map = {}
    if args.sprite_palette_map:
        sprite_pal_map = json.loads(Path(args.sprite_palette_map)
                                    .read_text(encoding="utf-8"))

    if args.size:
        m = re.match(r"(\d+)[xX](\d+)$", args.size.strip())
        if not m:
            die("--size must look like 10x9")
        w_blocks, h_blocks = int(m.group(1)), int(m.group(2))
    else:
        w_blocks, h_blocks = parse_map_dimensions(root, map_const)

    tileset_png = root / "gfx" / "tilesets" / f"{tileset_lower}.png"
    bst = root / "gfx" / "blocksets" / f"{tileset_lower}.bst"
    for p in (tileset_png, bst):
        if not p.exists():
            die(f"Missing required file: {p}")

    tiles = slice_tiles_from_png(tileset_png)
    blocks = read_bst_blocks(bst)

    blk = blk_path.read_bytes()
    expected = w_blocks * h_blocks
    # if len(blk) != expected:
    #     die(f".blk size {len(blk)} != width*height {expected} (map_const={map_const})")

    img = compose_map(blk, w_blocks, h_blocks, blocks, tiles)
    img = ensure_rgba(img)

    pal_rgb: Optional[List[Tuple[int, int, int]]] = None
    if args.palette:
        hexes = [s.strip() for s in args.palette.split(",") if s.strip()]
        if len(hexes) != 4:
            die("--palette needs exactly 4 hex colors (light→dark)")
        pal_rgb = [hex_to_rgb(h) for h in hexes]
    elif args.palette_preset:
        pal_rgb = preset_palette(args.palette_preset)
    elif args.palette_map:
        mp = json.loads(Path(args.palette_map).read_text(encoding="utf-8"))
        entry = mp.get(map_const, mp.get("_default"))
        if entry is None:
            die(f"No palette found for {map_const} and no _default in {args.palette_map}")
        if isinstance(entry, str):
            pal_rgb = preset_palette(entry)
        elif isinstance(entry, list) and len(entry) == 4:
            pal_rgb = [hex_to_rgb(h) for h in entry]
        else:
            die(f"Bad palette entry for {map_const}: {entry!r}")



    sgb_map = None
    if args.use_sgb:
        sgb_map = build_map_to_palette(
            Path(args.pokered),
            Path(args.pokered) / args.sgb_pal_file,
            Path(args.sgb_overrides) if args.sgb_overrides else None
        )

    if args.use_sgb:
        pal_hex = sgb_map.get(map_const)  # map_const you already resolve (e.g., PALLET_TOWN)
        if pal_hex:
            pal_rgb = [hex_to_rgb(h) for h in pal_hex]

    #print("Map", map_const, "palette", pal_hex)
    if pal_rgb:
        img = recolor_background_rgba(img, pal_rgb)


    if args.overlay_npcs:
        map_pascal = blk_path.stem
        obj_path = find_objects_asm(root, map_pascal)
        if obj_path and obj_path.exists():
            events = parse_object_events(obj_path, order=args.object_order)
            mode = args.object_coords
            if mode == "auto":
                mode = infer_coord_mode(events, w_blocks, h_blocks)
            scale = {"tiles": 8, "metatiles": 16, "blocks": 32}[mode]

            dx_tiles, dy_tiles = parse_offset_arg(args.object_offset)

            sprite_map: Dict[str, str] = {}
            if args.npc_mode == "sprites" and args.npc_sprite_map:
                sprite_map = json.loads(Path(args.npc_sprite_map).read_text(encoding="utf-8"))

            spr_pal: Optional[List[Tuple[int, int, int]]] = None
            if args.sprite_palette:
                shex = [s.strip() for s in args.sprite_palette.split(",") if s.strip()]
                if len(shex) != 4:
                    die("--sprite-palette needs 4 hex colors (light→dark)")
                spr_pal = [hex_to_rgb(h) for h in shex]

            img = ensure_rgba(img)
            for ev in events:
                x_px = (int(ev["x"]) + dx_tiles) * scale
                y_px = (int(ev["y"]) + dy_tiles) * scale
                

                if args.npc_mode == "sprites" and sprite_map:
                    sprite_frame = 0
                    if ev["facing"] == "UP":
                        sprite_frame = 1
                    elif ev["facing"] in {"LEFT", "RIGHT"}:
                        sprite_frame = 2

                    spr = load_sprite_png(root, sprite_map, str(ev["sprite"]), frame_index=sprite_frame)
                    if spr:
                        pal_override = None
                        token = str(ev["sprite"])
                        if token in sprite_pal_map:

                            pal_override = [hex_to_rgb(h) for h in sprite_pal_map[token]]
                        elif spr_pal:
                            pal_override = spr_pal  # global fallback

                        if pal_override:
                            spr = recolor_sprite_rgba(spr, pal_rgb, keep_white=True, flip_sprite=True)

                        if args.use_sgb:
                            pal_rgb = [hex_to_rgb(h) for h in pal_hex]
                        else:
                            pal_rgb = [(255,255,255), (170,170,170), (85,85,85), (0,0,0)]
                        spr = recolor_sprite_rgba(spr, pal_rgb, keep_white=True, flip_sprite=True)

                        if ev["facing"] == "RIGHT":
                            spr = spr.transpose(Image.FLIP_LEFT_RIGHT)
                        if ev["sprite"] != "SPRITE_POKE_BALL" and ev["sprite"] != "SPRITE_BOULDER":
                            y_px = y_px-4 # NPC sprites are offset up by 4px
                        img.alpha_composite(spr, (x_px, y_px))
                    else:
                        pass
                else:
                    pass

    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    img.save(out)
    print(f"Saved {out}  ({img.size[0]}x{img.size[1]}px)  map={map_const} tileset={tileset}")


if __name__ == "__main__":
    main()
