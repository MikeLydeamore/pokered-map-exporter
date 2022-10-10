RedsHouse1F_Script:
	jp EnableAutoTextBoxDrawing

RedsHouse1F_TextPointers:
	dw RedsHouse1FMomText
	dw RedsHouse1FTVText

RedsHouse1FMomText:
	text_asm
	ld a, [wd72e]
	bit 3, a ; received a Pokémon from Oak?
	jr nz, .heal
	ld hl, MomWakeUpText
	call PrintText
	jr .done
.heal
	call MomHealPokemon
.done
	jp TextScriptEnd

MomWakeUpText:
	text_far _MomWakeUpText
	text_end

MomHealPokemon:
    ld b, ULTRA_BALL
	call IsItemInBag
	jr nz, .noGift
    ld b, GREAT_BALL
	call IsItemInBag
	jr nz, .noGift
    ld b, POKE_BALL
	call IsItemInBag
	jr nz, .noGift
    ld b, OAKS_PARCEL
	call IsItemInBag
	jr nz, .noGift
    ld a, [wPlayerMoney]
    cp 1
    jr nc, .noGift
    ld a, [wPlayerMoney + 1]
    cp 2
    jr nc, .noGift
    ld a, HS_LYING_OLD_MAN
	ld c, a
	ld b, FLAG_TEST
	ld hl, wMissableObjectFlags
	farcall MissableObjectFlagAction
	ld a, c
	and a
	jr z, .noGift
	lb bc, POKE_BALL, 1
	call GiveItem
	ld hl, PokeballGiftText
	jp PrintText
.noGift
	ld hl, MomHealText1
	call PrintText
	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlaySound
.next
	ld a, [wChannelSoundIDs]
	cp MUSIC_PKMN_HEALED
	jr z, .next
	ld a, [wMapMusicSoundID]
	ld [wNewSoundID], a
	call PlaySound
	call GBFadeInFromWhite
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp 50
	jr c, .normalText
	ld hl, MomHealText3
	jp PrintText
.normalText
	ld hl, MomHealText2
	jp PrintText

PokeballGiftText:
	text "<PLAYER> received "
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

MomHealText1:
	text_far _MomHealText1
	text_end
MomHealText2:
	text_far _MomHealText2
	text_end
MomHealText3:
    text_far _MomHealText3
    text_end

RedsHouse1FTVText:
	text_asm
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ld hl, TVWrongSideText
	jr nz, .got_text
	ld hl, StandByMeText
.got_text
	call PrintText
	jp TextScriptEnd

StandByMeText:
	text_far _StandByMeText
	text_end

TVWrongSideText:
	text_far _TVWrongSideText
	text_end
