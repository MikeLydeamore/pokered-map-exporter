GiveItem::
; Give player quantity c of item b,
; and copy the item's name to wStringBuffer.
; Return carry on success.
	ld a, b
	ld [wd11e], a
	ld [wcf91], a
    cp AP_ITEM
    jp z, .apitem
    cp TEN_COINS
    jr nz, .no10coins
    farcall TenCoins
    jp .apitem
.no10coins
    cp TWENTY_COINS
    jr nz, .no20coins
    farcall TwentyCoins
    jr .apitem
.no20coins
    cp HUNDRED_COINS
    jr nz, .no100coins
    farcall HundredCoins
    jr .apitem
.no100coins
    cp POKEDEX
    jr nz, .nopokedex
    SetEvent EVENT_GOT_POKEDEX
    jr .apitem
.nopokedex
    cp POISON_TRAP
    jr nz, .nopoisontrap
    farcall PoisonTrap
    jr .apitem
.nopoisontrap
    cp PARALYZE_TRAP
    jr nz, .noparalyzetrap
    farcall ParalyzeTrap
    jr .apitem
.noparalyzetrap
    cp FIRE_TRAP
    jr nz, .nofiretrap
    farcall FireTrap
    jr .apitem
.nofiretrap
    CP ICE_TRAP
    jr nz, .noicetrap
    farcall IceTrap
    jr .apitem
.noicetrap
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
    ld c, 1
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
