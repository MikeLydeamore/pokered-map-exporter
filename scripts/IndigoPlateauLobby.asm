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
.Archipelago_Option_Pokemon_League_Badges_1
    ld a, 8
    ld [wcd6d], a
    ld hl, BadgesNeededText
    call PrintText
	ld hl, wObtainedBadges
	ld b, $1
	call CountSetBits
	ld a, [wNumSetBits]
	ld b, a
	inc b
	ld a, [wcd6d]
	cp b
	jr c, .enoughBadges
    ld hl, NotEnoughBadges
    call PrintText
	jp TextScriptEnd
.enoughBadges

    ld hl, EnoughBadges
    call PrintText
    call GBFadeOutToBlack
	ld a, HS_INDIGO_LEAGUE_GUARD
	ld [wMissableObjectIndex], a
	predef HideObject
	call GBFadeInFromBlack
	jp TextScriptEnd

BadgesNeededText:
    text "You can pass here"
	line "only if you have"
	cont "@"
	text_decimal wcd6d, 1, 1
	text " badges!"
    prompt

NotEnoughBadges:
	text "You don't have"
	line "@"
	text_decimal wcd6d, 1, 1
	text " badges yet!@"
	text_end

EnoughBadges:
	text "Oh! You do have"
	line "@"
	text_decimal wcd6d, 1, 1
	text " badges!"
	para "OK then! Please,"
	line "go right ahead!@"
	text_end

IndigoCashierText::
.Archipelago_Shop10
	script_mart ULTRA_BALL, GREAT_BALL, FULL_RESTORE, MAX_POTION, FULL_HEAL, REVIVE, MAX_REPEL
    ds 30, 0
