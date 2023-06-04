Route2Gate_Script:
	jp EnableAutoTextBoxDrawing

Route2Gate_TextPointers:
	dw Route2GateText1
	dw Route2GateText2

Route2GateText1:
	text_asm
	CheckEvent EVENT_GOT_HM05
	jr z, .Archipelago_Option_Aide_Rt2_1
	ld hl, Route2GateText_5d616
	call PrintText
	jp TextScriptEnd
.Archipelago_Option_Aide_Rt2_1
	ld a, 10
	ldh [hOaksAideRequirement], a
.Archipelago_Event_LD_A_Route_2_Oaks_Aide
	ld a, PROGRESSIVE_CARD_KEY ;HM_FLASH
	ldh [hOaksAideRewardItem], a
	ld [wd11e], a
	call GetItemName
	ld hl, wcd6d
	ld de, wOaksAideRewardItemName
	ld bc, ITEM_NAME_LENGTH
	call CopyData
	predef OaksAideScript
	ldh a, [hOaksAideResult]
	cp OAKS_AIDE_GOT_ITEM
	jr nz, .no_item
	SetEvent EVENT_GOT_HM05
.got_item
	;ld hl, Route2GateText_5d616
	;call PrintText
.no_item
	jp TextScriptEnd

Route2GateText_5d616:
	text_far _Route2GateText_5d616
	text_end

Route2GateText2:
	text_far _Route2GateText2
	text_end
