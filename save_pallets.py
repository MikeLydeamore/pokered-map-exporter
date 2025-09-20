import re
from pathlib import Path
from PIL import Image, ImageDraw

def gb_to_rgb(r, g, b):
    # GB palette values are 0–31; scale to 0–255
    return (r * 8, g * 8, b * 8)

# Load the provided sgb_palettes.asm
sgb_file = Path("data\sgb\sgb_palettes.asm")
text = sgb_file.read_text(encoding="utf-8", errors="ignore")

palette_re = re.compile(
    r"RGB\s+(\d+),\s*(\d+),\s*(\d+),"
    r"\s*(\d+),\s*(\d+),\s*(\d+),"
    r"\s*(\d+),\s*(\d+),\s*(\d+),"
    r"\s*(\d+),\s*(\d+),\s*(\d+)\s*;\s*(PAL_\w+)"
)

palettes = []
for m in palette_re.finditer(text):
    cols = [gb_to_rgb(int(m.group(i)), int(m.group(i+1)), int(m.group(i+2)))
            for i in (1,4,7,10)]
    name = m.group(13)
    palettes.append((name, cols))

# Create an image with swatches
swatch_w, swatch_h = 40, 40
margin, spacing = 10, 10

rows = len(palettes)
img_w = 400
img_h = rows * (swatch_h + spacing) + margin

image = Image.new("RGB", (img_w, img_h), "white")
draw = ImageDraw.Draw(image)

y = margin
for name, cols in palettes:
    # draw name
    draw.text((margin, y), name, fill="black")
    # draw swatches
    for i, col in enumerate(cols):
        x = 150 + i*(swatch_w+5)
        draw.rectangle([x, y, x+swatch_w, y+swatch_h], fill=col, outline="black")
    y += swatch_h + spacing

out_path = "sgb_palettes.png"
image.save(out_path)