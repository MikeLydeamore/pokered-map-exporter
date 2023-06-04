Route23_Script:
	call Route23Script_511e9
	call EnableAutoTextBoxDrawing
	ld hl, Route23_ScriptPointers
	ld a, [wRoute23CurScript]
	jp CallFunctionInTable

Route23Script_511e9:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z
	;ResetEvents EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1, EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH2
	;ResetEvents EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH1, EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH2
	;ld a, HS_VICTORY_ROAD_3F_BOULDER
	;ld [wMissableObjectIndex], a
	;predef ShowObject
	;ld a, HS_VICTORY_ROAD_2F_BOULDER
	;ld [wMissableObjectIndex], a
	;predef_jump HideObject

Route23_ScriptPointers:
	dw Route23Script0
	dw Route23Script1
	dw Route23Script2

Route23Script0:
	ld a, [wYCoord]
	cp 35
	ret nz

	CheckEvent EVENT_PASSED_CASCADEBADGE_CHECK
	ret nz
    ld a, 1
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
    ret


Route23Script1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
Route23Script2:
	ld a, $0
	ld [wRoute23CurScript], a
	ret

Route23_TextPointers:
	dw Route23Text1
	dw Route23Text2
	dw Route23Text3
	dw Route23Text4
	dw Route23Text5
	dw Route23Text6
	dw Route23Text7
	dw Route23Text8

Route23Text1:
	text_asm
	ld hl, wObtainedBadges
	ld b, 1
	call CountSetBits
	ld a, [wNumSetBits]
.Archipelago_Option_Route23_Badges_1
	cp 0
	jr nc, .proceed
	ld hl, VictoryRoadGuardText1
    call PrintText
    xor a
	ldh [hJoyHeld], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
    ld a, [wPlayerDirection]
    cp PLAYER_DIR_UP
    ld a, D_UP
    jr nz, .Up
	ld a, D_DOWN
.Up
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	jp StartSimulatingJoypadStates
	ld a, $1
	ld [wRoute10CurScript], a
.proceed
    ld hl, VictoryRoadGuardText2
    call PrintText
    SetEvent EVENT_PASSED_CASCADEBADGE_CHECK
	jp TextScriptEnd


VictoryRoadGuardText1:
	text_far _VictoryRoadGuardText1
	text_asm
	ld a, SFX_DENIED
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	jp TextScriptEnd

VictoryRoadGuardText2:
	text_far _VictoryRoadGuardText2
	sound_get_item_1
	text_far _VictoryRoadGuardText_513a3
	text_end

Route23Text2:
Route23Text3:
Route23Text4:
Route23Text5:
Route23Text6:
Route23Text7:
Route23Text8:
	text_far _Route23Text8
	text_end
