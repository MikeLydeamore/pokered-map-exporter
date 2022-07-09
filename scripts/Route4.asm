Route4_Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route4TrainerHeaders
	ld de, Route4_ScriptPointers
	ld a, [wRoute4CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute4CurScript], a
	ret

Route4_ScriptPointers:
    dw rt4oldman
    dw Route4WalkDown
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

rt4oldman:
	CheckEvent EVENT_GOT_POKEDEX
	ret nz
	ld a, [wMissableObjectFlags + 3]
	bit 4, a
	ret nz
	ld a, [wYCoord]
	cp 6
	ret nz
	ld a, [wXCoord]
	cp 18
	ret nz
	ld a, $4
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ldh [hJoyHeld], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpritePlayerStateData1FacingDirection], a
	ld [wJoyIgnore], a
	ret
	ld a, $3
	ld [wViridianCityCurScript], a
	ret

Route4WalkDown:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, 0
	ld [wViridianCityCurScript], a
	ret

Route4_TextPointers:
	dw Route4Text1
	dw Route4Text2
	dw PickUpItemText
	dw Route4OldMan
	dw PokeCenterSignText
	dw Route4Text5
	dw Route4Text6

Route4TrainerHeaders:
	def_trainers 2
Route4TrainerHeader0:
	trainer EVENT_BEAT_ROUTE_4_TRAINER_0, 3, Route4BattleText1, Route4EndBattleText1, Route4AfterBattleText1
	db -1 ; end

Route4Text1:
	text_far _Route4Text1
	text_end

Route4Text2:
	text_asm
	ld hl, Route4TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route4BattleText1:
	text_far _Route4BattleText1
	text_end

Route4EndBattleText1:
	text_far _Route4EndBattleText1
	text_end

Route4AfterBattleText1:
	text_far _Route4AfterBattleText1
	text_end

Route4Text5:
	text_far _Route4Text5
	text_end

Route4Text6:
	text_far _Route4Text6
	text_end

Route4OldMan:
    text "No one enters Mt"
    line "Moon before I've"
    cont "had my coffee!"
    done
