SilphCo1F_Script:
	call EnableAutoTextBoxDrawing
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret z
	CheckAndSetEvent EVENT_SILPH_CO_RECEPTIONIST_AT_DESK
	ret nz
	ld a, HS_SILPH_CO_1F_RECEPTIONIST
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

SilphCo1F_TextPointers:
	dw SilphCo1Text1

SilphCo1Text1:
	text_asm
	ld hl, SplitKeyChecks
	ld a, [hl]
	and a
	jr z, .noSP
	CheckEvent EVENT_SKC_1F
	jr nz, .noSP
.Archipelago_Event_SKC1F
	lb bc, CARD_KEY_2F, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, DisplayArchipelagoItem
	call PrintText
	SetEvent EVENT_SKC_1F
	jp TextScriptEnd
.bag_full
	ld hl, SKC1NoRoomText
	call PrintText
	jp TextScriptEnd
.noSP
    ld hl, SilphCo1Text1b
    call PrintText
    jp TextScriptEnd

SilphCo1Text1b:
    text_far _SilphCo1Text1
	text_end

SKC1NoRoomText:
    text_far TM42NoRoomText
    text_end