GiveItem::
; Give player quantity c of item b,
; and copy the item's name to wStringBuffer.
; Return carry on success.
	ld a, b
	ld [wd11e], a
	ld [wcf91], a
    cp AP_ITEM
    jr z, .apitem
    cp POKEDEX
    jr z, .pokedex
    cp POISON_TRAP
    jr z, .poisontrap
    cp PARALYZE_TRAP
    jr z, .paralyzetrap
    cp FIRE_TRAP
    jr z, .firetrap
    CP ICE_TRAP
    jr z, .icetrap
    ;ld hl, BadgeList
    ;ld a, hli
    ld a, BOULDERBADGE - 1
.loop1
    cp EARTHBADGE
    jr z, .continue
    inc a
    cp b
    jr nz, .loop1
; match found
    ld a, 1
    ld c, a
    ld a, b
    sub a, BOULDERBADGE
    ;ld b, a
    jr .skipsla
.loop2
    SLA c
    dec a
.skipsla
    cp 0
    jr nz, .loop2
    ld a, [wObtainedBadges]
    or c
    ld [wObtainedBadges], a
    jr .apitem
.continue
	ld a, c
	ld [wItemQuantity], a
	ld hl, wNumBagItems
	call AddItemToInventory
	ret nc
.apitem
	call GetItemName
	call CopyToStringBuffer
	scf
	ret
.pokedex
    SetEvent EVENT_GOT_POKEDEX
    jr .apitem
.poisontrap
    farcall PoisonTrap
    jr .apitem
.paralyzetrap
    farcall ParalyzeTrap
    jr .apitem
.firetrap
    farcall FireTrap
    jr .apitem
.icetrap
    farcall IceTrap
    jr .apitem


;BadgeList:
;db BOULDERBADGE
;db CASCADEBADGE
;db THUNDERBADGE
;db RAINBOWBADGE
;db SOULBADGE
;db MARSHBADGE
;db VOLCANOBADGE;
;db EARTHBADGE
;db $FF

GivePokemon::
; Give the player monster b at level c.
	ld a, b
	ld [wcf91], a
	ld a, c
	ld [wCurEnemyLVL], a
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	farjp _GivePokemon
