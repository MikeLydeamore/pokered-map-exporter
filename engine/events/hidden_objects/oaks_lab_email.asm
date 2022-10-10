DisplayOakLabEmailText:
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	call EnableAutoTextBoxDrawing
	tx_pre_jump OakLabEmailText

OakLabEmailText::
    text_asm
	ld hl, EMGA
    call PrintText
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld a, [wNumSetBits]
	cp 50
	jr c, .levelGreen
	cp 75
    jr c, .levelBlue
    cp 100
    jr c, .levelYellow
    cp 125
    jr c, .levelOrange
    cp 150
    jr c, .levelRed
    ld hl, levelCriticalText
    jr .done
.levelGreen
    ld hl, levelGreenText
    jr .done
.levelBlue
    ld hl, levelBlueText
    jr .done
.levelYellow
    ld hl, levelYellowText
    jr .done
.levelOrange
    ld hl, levelOrangeText
    jr .done
.levelRed
    ld hl, levelRedText
.done
    jp PrintText

EMGA:
	text "Epsilon Minus"
	line "Girlfriend Alert"
	prompt

levelGreenText:
    text_far _levelGreenText
	text_end

_levelGreenText:
	text "Status:"
	line "Level Green."
	done

levelBlueText:
    text_far _levelBlueText
	text_end
	text_end

_levelBlueText:
	text "Status:"
	line "Level Blue."

	para "Uh oh!"
    done

levelYellowText:
    text_far _levelYellowText
	text_end
	text_end

_levelYellowText:
	text "Status:"
	line "Level Yellow."

	para "Uh oh!"
	done

levelOrangeText:
    text_far _levelOrangeText
    text_end
	text_end

_levelOrangeText:
	text "Status:"
	line "Level Orange."

	para "¥▲♀ぉ!"
	done

levelRedText:
    text_far _levelRedText
    text_end
	text_end

_levelRedText:
	text "Status:"
	line "Level Red."

	para "Oh ♂ぁ▼¥!"
	line "He's all up in it!"
	done

levelCriticalText:
    text_far _levelCriticalText
    text_end
	text_end

_levelCriticalText:
	text "Status:"
	line "Critical!"

	para "Red alert!"

	para "Red alert!"

	para "He's doing your"
	cont "girlfriend!"

	para "                  "
	line "                  "

	para "Son of a ♀¥ぅ▷♂!"

	para "He's in the back"
	line "door!"
	done

