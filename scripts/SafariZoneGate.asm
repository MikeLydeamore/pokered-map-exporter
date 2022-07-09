SafariZoneGate_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SafariZoneGate_ScriptPointers
	ld a, [wSafariZoneGateCurScript]
	jp CallFunctionInTable

SafariZoneGate_ScriptPointers:
	dw .SafariZoneEntranceScript0
	dw .SafariZoneEntranceScript1
	dw .SafariZoneEntranceScript2
	dw .SafariZoneEntranceScript3
	dw .SafariZoneEntranceScript4
	dw .SafariZoneEntranceScript5
	dw .SafariZoneEntranceScript6

.SafariZoneEntranceScript0
	ld hl, .CoordsData_75221
	call ArePlayerCoordsInArray
	ret nc
	ld a, $3
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	xor a
	ldh [hJoyHeld], a
	ld a, SPRITE_FACING_RIGHT
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, [wCoordIndex]
	cp $1
	jr z, .asm_7520f
	ld a, $2
	ld [wSafariZoneGateCurScript], a
	ret
.asm_7520f
	ld a, D_RIGHT
	ld c, $1
	call SafariZoneEntranceAutoWalk
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ld [wSafariZoneGateCurScript], a
	ret

.CoordsData_75221:
	dbmapcoord  3,  2
	dbmapcoord  4,  2
	db -1 ; end

.SafariZoneEntranceScript1
	call SafariZoneEntranceScript_752b4
	ret nz
.SafariZoneEntranceScript2
	xor a
	ldh [hJoyHeld], a
	ld [wJoyIgnore], a
	call UpdateSprites
	ld a, $4
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	ret

.SafariZoneEntranceScript3
	call SafariZoneEntranceScript_752b4
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $5
	ld [wSafariZoneGateCurScript], a
	ret

.SafariZoneEntranceScript5
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	CheckAndResetEvent EVENT_SAFARI_GAME_OVER
	jr z, .asm_7527f
	ResetEventReuseHL EVENT_IN_SAFARI_ZONE
	call UpdateSprites
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $6
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wNumSafariBalls], a
	ld a, D_DOWN
	ld c, $3
	call SafariZoneEntranceAutoWalk
	ld a, $4
	ld [wSafariZoneGateCurScript], a
	jr .asm_75286
.asm_7527f
	ld a, $5
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_75286
	ret

.SafariZoneEntranceScript4
	call SafariZoneEntranceScript_752b4
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wSafariZoneGateCurScript], a
	ret

.SafariZoneEntranceScript6
	call SafariZoneEntranceScript_752b4
	ret nz
	call Delay3
	ld a, [wcf0d]
	ld [wSafariZoneGateCurScript], a
	ret

SafariZoneEntranceAutoWalk:
	push af
	ld b, 0
	ld a, c
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wSimulatedJoypadStatesEnd
	pop af
	call FillMemory
	jp StartSimulatingJoypadStates

SafariZoneEntranceScript_752b4:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret

SafariZoneGate_TextPointers:
	dw .SafariZoneEntranceText1
	dw .SafariZoneEntranceText2
	dw .SafariZoneEntranceText1
	dw .SafariZoneEntranceText4
	dw .SafariZoneEntranceText5
	dw .SafariZoneEntranceText6

.SafariZoneEntranceText1
	text_far _SafariZoneEntranceText1
	text_end

.SafariZoneEntranceText4
	text_asm
	ld b, SAFARI_PASS
	call IsItemInBag
	jp nz, .hasCard
	;ld hl, SafariZoneEntranceText_9e6e4
	;call PrintText
	ld hl, SafariZoneEntranceText_1
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, A_BUTTON | B_BUTTON
	ld [wMenuWatchedKeys], a
	ld a, $1
	ld [wMaxMenuItem], a
	ld a, $2
	ld [wTopMenuItemY], a
	ld a, $1
	ld [wTopMenuItemX], a
	ld hl, wd730
	set 6, [hl]
	hlcoord 0, 0
	ld b, 4
	ld c, 15
	call TextBoxBorder
	call UpdateSprites
	hlcoord 2, 2
	ld de, SafariPassText
	call PlaceString
	hlcoord 8, 3
	ld de, SafariPassMenuPrice
	call PlaceString
	;ld hl, SafariZoneEntranceText_2
	;call PrintText
	call HandleMenuInput
	bit BIT_B_BUTTON, a
	jr nz, .cancel
	ld hl, wd730
	res 6, [hl]
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cancel
	ld hl, SafariPassCantAffordText
	call PrintText
.cancel
	ld hl, .PleaseComeAgainText
	call PrintText
.Done
	;jp TextScriptEnd

	jr .CantPayWalkDown

.hasCard
    ld hl, SafariZoneEntranceText_9e747
	call PrintText
	ld a, 30
	ld [wNumSafariBalls], a
	ld a, HIGH(502)
	ld [wSafariSteps], a
	ld a, LOW(502)
	ld [wSafariSteps + 1], a
	ld a, D_UP
	ld c, 3
	call SafariZoneEntranceAutoWalk
	SetEvent EVENT_IN_SAFARI_ZONE
	ResetEventReuseHL EVENT_SAFARI_GAME_OVER
	ld a, 3
	ld [wSafariZoneGateCurScript], a
	jr .done

.PleaseComeAgain
	ld hl, .PleaseComeAgainText
	call PrintText
.CantPayWalkDown
	ld a, D_DOWN
	ld c, 1
	call SafariZoneEntranceAutoWalk
	ld a, 4
	ld [wSafariZoneGateCurScript], a
.done
	jp TextScriptEnd

.MakePaymentText
	text_far SafariZoneEntranceText_9e747
	sound_get_item_1
	text_far _SafariZoneEntranceText_75360
	text_end

.PleaseComeAgainText
	text_far _SafariZoneEntranceText_75365
	text_end

.NotEnoughMoneyText
	text_far _SafariZoneEntranceText_7536a
	text_end

.SafariZoneEntranceText5
	text_far SafariZoneEntranceText_9e814
	text_asm
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_7539c
	ld hl, .SafariZoneEntranceText_753bb
	call PrintText
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, D_DOWN
	ld c, $3
	call SafariZoneEntranceAutoWalk
	ResetEvents EVENT_SAFARI_GAME_OVER, EVENT_IN_SAFARI_ZONE
	ld a, $0
	ld [wcf0d], a
	jr .asm_753b3
.asm_7539c
	ld hl, .SafariZoneEntranceText_753c0
	call PrintText
	ld a, SPRITE_FACING_UP
	ld [wSpritePlayerStateData1FacingDirection], a
	ld a, D_UP
	ld c, $1
	call SafariZoneEntranceAutoWalk
	ld a, $5
	ld [wcf0d], a
.asm_753b3
	ld a, $6
	ld [wSafariZoneGateCurScript], a
	jp TextScriptEnd

.SafariZoneEntranceText_753bb
	text_far _SafariZoneEntranceText_753bb
	text_end

.SafariZoneEntranceText_753c0
	text_far _SafariZoneEntranceText_753c0
	text_end

.SafariZoneEntranceText6
	text_far _SafariZoneEntranceText_753c5
	text_end

.SafariZoneEntranceText2
	text_asm
	ld hl, .FirstTimeQuestionText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, .RegularText
	jr nz, .Explanation
	ld hl, .ExplanationText
.Explanation
	call PrintText
	jp TextScriptEnd

.FirstTimeQuestionText
	text_far _SafariZoneEntranceText_753e6
	text_end

.ExplanationText
	text_far _SafariZoneEntranceText_753eb
	text_end

.RegularText
	text_far _SafariZoneEntranceText_753f0
	text_end

SafariZoneEntranceText_1::
	;text "For just ¥500,"
	;line "you can catch all"
	;cont "the #MON you"
	;cont "want in the park!"

	;para "Would you like to"
	;line "join the hunt?@"
	;text "Unfortunately we"
	;line "are not currently"
	;cont "accepting new"
	;cont "members at this"
    ;cont "time.@"
    ;text "Welcome to the"
    ;line "Safari Zone!"
	;prompt

SafariZoneEntranceText_2::
    text "Would you like to"
    line "purchase a season"
    cont "pass?"
    done

SafariPassText:
	db   "SAFARI PASS"
	next "CANCEL@"

SafariZoneEntranceText_9e747::
	;text "That'll be ¥500"
	;line "please!"

	;para "We only use a"
	;line "special # BALL"
	;cont "here."
	text "Ah, a season pass!"
	line "Right this way!"

	para "<PLAYER> received"
	line "30 SAFARI BALLs!@"
	text_end

SafariPassMenuPrice:
	db "¥1000000@"

SafariPassComeAgainText::
	text "Come back again"
	line "some time!"
	done

SafariPassCantAffordText::
	text "Sorry! You can't"
	line "afford it!"
	prompt