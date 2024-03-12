IPKeyItems:
    db OAKS_PARCEL
    db BIKE_VOUCHER
    db GOLD_TEETH
    db HELIX_FOSSIL
    db DOME_FOSSIL
    db OLD_AMBER
    db TEA
    db SECRET_KEY
    db BICYCLE
    db SILPH_SCOPE
    db ITEMFINDER
    db SUPER_ROD
    db GOOD_ROD
    db OLD_ROD
    db LIFT_KEY
    db CARD_KEY
    db TOWN_MAP
    db COIN_CASE
    db POKE_FLUTE
    db S_S_TICKET
    db EXP_ALL
    db MANSION_KEY
    db SAFARI_PASS
    db PLANT_KEY
    db HIDEOUT_KEY
    db CARD_KEY_2F
    db CARD_KEY_3F
    db CARD_KEY_4F
    db CARD_KEY_5F
    db CARD_KEY_6F
    db CARD_KEY_7F
    db CARD_KEY_8F
    db CARD_KEY_9F
    db CARD_KEY_10F
    db CARD_KEY_11F
    db MOON_STONE
    db FIRE_STONE
    db LEAF_STONE
    db THUNDER_STONE
    db WATER_STONE
    db $FF

IndigoPlateauLobby_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z
	ResetEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	ld hl, wBeatLorelei
	bit 1, [hl]
	res 1, [hl]
	ret z
	; Elite 4 events
	ResetEventRange ELITE4_EVENTS_START, EVENT_LANCES_ROOM_LOCK_DOOR
	ret

IndigoPlateauLobby_TextPointers:
	dw IndigoHealNurseText
	dw IndigoPlateauLobbyText2
	dw IndigoPlateauLobbyText3
	dw IndigoCashierText
	dw IndigoTradeNurseText
	dw IndigoGuardText

IndigoHealNurseText:
	script_pokecenter_nurse

IndigoPlateauLobbyText2:
	text_far _IndigoPlateauLobbyText2
	text_end

IndigoPlateauLobbyText3:
	text_far _IndigoPlateauLobbyText3
	text_end

IndigoTradeNurseText:
	script_cable_club_receptionist

IndigoGuardText:
    text_asm
    ld hl, .Archipelago_Option_Elite_Four_Pokedex_1 + 1
    ld a, [hl]
    cp 0
.Archipelago_Require_Pokedex_D_0 ; turns it into jr .afterDexCheck if off
    jr z, .afterDexCheck
    CheckEvent EVENT_GOT_POKEDEX
    jr nz, .afterDexCheck
    ld hl, noDex
    call PrintText
	jp TextScriptEnd
.afterDexCheck
    ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ld [wUnusedD71F], a

	ld hl, wObtainedBadges
	ld b, $1
	call CountSetBits
	ld a, [wNumSetBits]
	ld [wUnusedCC5B], a

	ld c, 0
	ld hl, IPKeyItems
.loop
	ld a, [hli]
	cp $FF
	jr z, .doneLoop
	ld b, a
	push bc
	push hl
	call IsItemInBag
	pop hl
	pop bc
	jr z, .loop
	inc c
	jr .loop
.doneLoop
    CheckEvent EVENT_GAVE_OLD_AMBER
    jr z, .nooa
    inc c
.nooa
    CheckEvent EVENT_GAVE_HELIX_FOSSIL
    jr z, .nohf
    inc c
.nohf
    CheckEvent EVENT_GAVE_DOME_FOSSIL
    jr z, .nodf
    inc c
.nodf
    CheckEvent EVENT_GAVE_GOLD_TEETH
    jr z, .nogt
    inc c
.nogt
    CheckEvent EVENT_GOT_BICYCLE
    jr z, .nobkvchr
    inc c
.nobkvchr
    CheckEvent EVENT_GAVE_PARCEL
    jr z, .noparc
    inc c
.noparc
    ld a, [wd728]
	bit 6, a
.Archipelago_Tea_Key_Item_B_0
    jr .notea
    inc c
.notea
    ld a, c
    ld [wUnusedD366], a
.Archipelago_Option_Elite_Four_Key_Items_1
    cp 0
    jr c, .dontleave
    ld a, [wUnusedD71F]
.Archipelago_Option_Elite_Four_Pokedex_1
    cp 0
    jr c, .dontleave
    ld a, [wUnusedCC5B]
.Archipelago_Option_Elite_Four_Badges_1
    cp 0
    jr c, .dontleave


    ld hl, BadgeGuyText
	call PrintText
    ld hl, EnoughBadges
    call PrintText
    call GBFadeOutToBlack
	ld a, HS_INDIGO_LEAGUE_GUARD
	ld [wMissableObjectIndex], a
	predef HideObject
	call GBFadeInFromBlack
	jp TextScriptEnd

.dontleave

    ld hl, BadgeGuyText
	call PrintText
	jp TextScriptEnd

noDex:
          ;;;;;;;;;;;;;;;;;;
    text "You need a"
    line "#DEX for me to"
    cont "check that you've"
    cont "met your goal for"
    cont "owned #MON.@"
    text_end

BadgeGuyText:

    text "To pass through,"
    line "you need a total"
    cont "of "
.Archipelago_Text_Elite_Four_Badges_0
    db "0 badges,"
.Archipelago_Text_Elite_Four_Key_Items_1
    cont "0 key items, and  "
.Archipelago_Text_Elite_Four_Pokedex_1
    cont "0 #MON    "
    cont "owned."
    para "You have @"
	text_decimal wUnusedCC5B, 1, 1
	text " badges,"
	line "@"
	text_decimal wUnusedD366, 1, 2
	text " key items,"
	cont "and @"
	text_decimal wUnusedD71F, 1, 3
	text " #MON"
	cont "owned."
	prompt


NotEnoughBadges:
                            ;
	text "You have not met"
	line "your goal yet!@"
	text_end

EnoughBadges:
	text "Oh, You have met"
	line "your goal!"
	para "OK then! Please,"
	line "go right ahead!@"
	text_end

IndigoCashierText::
.Archipelago_Shop10
	script_mart ULTRA_BALL, GREAT_BALL, FULL_RESTORE, MAX_POTION, FULL_HEAL, REVIVE, MAX_REPEL
    ds 30, 0
