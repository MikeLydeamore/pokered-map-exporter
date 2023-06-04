GiveItem::
; Give player quantity c of item b,
; and copy the item's name to wStringBuffer.
; Return carry on success.
    ld a, b
    ld [wd11e], a
    ld a, c
	ld [wcf91], a
    farcall _GiveItem
    ret



SplitKeyChecks::
.Archipelago_Option_Split_Card_Key_0
db $0
FixCombatBugs::
.Archipelago_Option_Fix_Combat_Bugs_0
db $0


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
