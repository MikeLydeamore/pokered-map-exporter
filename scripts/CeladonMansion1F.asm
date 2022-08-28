CeladonMansion1F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion1F_TextPointers:
	dw CeladonMansion1Text1
	dw CeladonMansion1Text2
	dw CeladonMansion1Text3
	dw CeladonMansion1Text4
	dw CeladonMansion1Text5

CeladonMansion1_PlayCryScript:
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text1:
	text_far _CeladonMansion1Text1
	text_asm
	ld a, MEOWTH
	jp CeladonMansion1_PlayCryScript

CeladonMansion1Text2:
    text_asm
    CheckEvent EVENT_GOT_TEA
    jr nz, .proceed
.Archipelago_Event_Mansion_Lady
	lb bc, TEA, 1
	call GiveItem
	jr nc, .bag_full
    ld hl, tea_text
    call PrintText
    SetEvent EVENT_GOT_TEA
    jp TextScriptEnd
.bag_full
    ld hl, CeladonMansion1TextNoRoom
    call PrintText
    jp TextScriptEnd
.proceed
    ld hl, CeladonMansion1Text2orig
    call PrintText
    jp TextScriptEnd

tea_text:
	text_far _ReceivedTM27Text
	sound_get_item_1
	text_end

CeladonMansion1TextNoRoom:
    text_far _FuchsiaHouse3Text_5621c
    text_end
CeladonMansion1Text2orig:
	text_far _CeladonMansion1Text2
	text_end
CeladonMansion1Text3:
	text_far _CeladonMansion1Text3
	text_asm
	ld a, CLEFAIRY
	jp CeladonMansion1_PlayCryScript

CeladonMansion1Text4:
	text_far _CeladonMansion1Text4
	text_asm
	ld a, NIDORAN_F
	jp CeladonMansion1_PlayCryScript

CeladonMansion1Text5:
	text_far _CeladonMansion1Text5
	text_end
