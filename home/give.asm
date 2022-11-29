GiveItem::
; Give player quantity c of item b,
; and copy the item's name to wStringBuffer.
; Return carry on success.
    farcall _GiveItem
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
