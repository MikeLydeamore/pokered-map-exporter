Route22Gate_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route22Gate_ScriptPointers
	ld a, [wRoute22GateCurScript]
	call CallFunctionInTable
	ld a, [wYCoord]
	cp 4
	ld a, ROUTE_23
	jr c, .asm_1e69a
	ld a, ROUTE_22
.asm_1e69a
	ld [wLastMap], a
	ret

Route22Gate_ScriptPointers:
	dw Route22GateScript0
	dw Route22GateScript1
	dw Route22GateScript2

Route22GateScript0:
	ld hl, Route22GateScriptCoords
	call ArePlayerCoordsInArray
	ret nc
	xor a
	ldh [hJoyHeld], a
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	jp DisplayTextID

Route22GateScriptCoords:
	dbmapcoord  4,  2
	dbmapcoord  5,  2
	db -1 ; end

Route22GateScript_1e6ba:
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	jp StartSimulatingJoypadStates

Route22GateScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	call Delay3
	ld a, $0
	ld [wRoute22GateCurScript], a
Route22GateScript2:
	ret

Route22Gate_TextPointers:
	dw Route22GateText1

Route22GateText1:
	text_asm
	;ld a, [wObtainedBadges]
	;bit BIT_BOULDERBADGE, a
.Archipelago_Option_Victory_Road_Badges_1
    ld a, 8
    ld [wcd6d], a
	;jr nc, .asm_1e6f6
	;jr nz, .asm_1e6f6
	ld hl, BadgesNeededTextv
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

	ld hl, NotEnoughBadgesv
	call PrintText

	call Route22GateScript_1e6ba
	ld a, $1
	jr .asm_1e6fe
.enoughBadges
	ld hl, EnoughBadgesv
	call PrintText
	ld a, $2
.asm_1e6fe
	ld [wRoute22GateCurScript], a
	jp TextScriptEnd

Route22GateText_1e704:
	text_far _Route22GateText_1e704
	text_asm
	ld a, SFX_DENIED
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld hl, Route22GateText_1e715
	ret

Route22GateText_1e715:
	text_far _Route22GateText_1e715
	text_end

Route22GateText_1e71a:
	text_far _Route22GateText_1e71a
	sound_get_item_1
	text_end

BadgesNeededTextv:
    text "You can pass here"
	line "only if you have"
	cont "@"
	text_decimal wcd6d, 1, 1
	text " badges!"
    prompt

NotEnoughBadgesv:
	text "You don't have"
	line "@"
	text_decimal wcd6d, 1, 1
	text " badges yet!@"
	text_end

EnoughBadgesv:
	text "Oh! You do have"
	line "@"
	text_decimal wcd6d, 1, 1
	text " badges!"
	para "OK then! Please,"
	line "go right ahead!@"
	text_end