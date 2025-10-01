$root       = "D:\Work\pokered"
$mapsDir    = Join-Path $root "maps"
$outDir     = Join-Path $root "out\maps_with_npcs\grayscale"

$palJson    = Join-Path $root "gbc_palettes.json"
$spriteJson = Join-Path $root "npc_sprites.json"
$spritePal  = Join-Path $root "sprite_palettes.json"

New-Item -ItemType Directory -Force -Path $outDir | Out-Null

Get-ChildItem -Path $mapsDir -Filter *.blk | ForEach-Object {
    $dest = Join-Path $outDir ($_.BaseName + ".png")

    & python ".\export_map_png_no_rgbds.py" `
    --pokered $root `
    --blk $_.FullName `
    --out $dest.ToLower() `
    --overlay-npcs --npc-mode sprites `
    --npc-sprite-map $spriteJson `
    --sprite-palette-map $spritePal `
    --object-coords metatiles `
    --object-order yx `
    --object-offset 0,0 `
    --sprite-frame 0 `
    --sprite-brighten 0 `
    --sprite-gamma 4

    Write-Host "Saved $dest"
}


# python ".\export_map_png_no_rgbds.py" `
#     --pokered $root `
#     --blk D:\Work\pokered\maps\UndergroundPathNorthSouth.blk `
#     --out D:\Work\pokered\out\sgb\UndergroundPathNorthSouth.png `
#     --use-sgb `
#     --overlay-npcs --npc-mode sprites `
#     --npc-sprite-map $spriteJson `
#     --sprite-palette-map $spritePal `
#     --object-coords metatiles `
#     --object-order yx `
#     --object-offset 0,0 `
#     --sprite-frame 0 `
#     --sprite-brighten 0 `
#     --sprite-gamma 4