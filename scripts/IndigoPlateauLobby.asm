IPKeyItems:
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
