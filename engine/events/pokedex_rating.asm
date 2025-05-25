DisplayDexRating:
    call CheckMissingTrainersanity
    call CheckAllDexSanity

	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen
	call CountSetBits
	ld a, [wNumSetBits]
	ldh [hDexRatingNumMonsSeen], a
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	ldh [hDexRatingNumMonsOwned], a
	ld hl, DexRatingsTable
.findRating
	ld a, [hli]
	ld b, a
	ldh a, [hDexRatingNumMonsOwned]
	cp b
	jr c, .foundRating
	inc hl
	inc hl
	jr .findRating
.foundRating
	ld a, [hli]
	ld h, [hl]
	ld l, a ; load text pointer into hl
	CheckAndResetEventA EVENT_HALL_OF_FAME_DEX_RATING
	jr nz, .hallOfFame
	push hl
	ld hl, PokedexRatingText_441cc
	call PrintText
	pop hl
	call PrintText
	farcall PlayPokedexRatingSfx
	jp WaitForTextScrollButtonPress
.hallOfFame
	ld de, wDexRatingNumMonsSeen
	ldh a, [hDexRatingNumMonsSeen]
	ld [de], a
	inc de
	ldh a, [hDexRatingNumMonsOwned]
	ld [de], a
	inc de
.copyRatingTextLoop
	ld a, [hli]
	cp "@"
	jr z, .doneCopying
	ld [de], a
	inc de
	jr .copyRatingTextLoop
.doneCopying
	ld [de], a
	ret

PokedexRatingText_441cc:
	text_far _OaksLabText_441cc
	text_end

DexRatingsTable:
	dbw 10, PokedexRatingText_44201
	dbw 20, PokedexRatingText_44206
	dbw 30, PokedexRatingText_4420b
	dbw 40, PokedexRatingText_44210
	dbw 50, PokedexRatingText_44215
	dbw 60, PokedexRatingText_4421a
	dbw 70, PokedexRatingText_4421f
	dbw 80, PokedexRatingText_44224
	dbw 90, PokedexRatingText_44229
	dbw 100, PokedexRatingText_4422e
	dbw 110, PokedexRatingText_44233
	dbw 120, PokedexRatingText_44238
	dbw 130, PokedexRatingText_4423d
	dbw 140, PokedexRatingText_44242
	dbw 150, PokedexRatingText_44247
	dbw NUM_POKEMON + 1, PokedexRatingText_4424c

PokedexRatingText_44201:
	text_far _OaksLabText_44201
	text_end

PokedexRatingText_44206:
	text_far _OaksLabText_44206
	text_end

PokedexRatingText_4420b:
	text_far _OaksLabText_4420b
	text_end

PokedexRatingText_44210:
	text_far _OaksLabText_44210
	text_end

PokedexRatingText_44215:
	text_far _OaksLabText_44215
	text_end

PokedexRatingText_4421a:
	text_far _OaksLabText_4421a
	text_end

PokedexRatingText_4421f:
	text_far _OaksLabText_4421f
	text_end

PokedexRatingText_44224:
	text_far _OaksLabText_44224
	text_end

PokedexRatingText_44229:
	text_far _OaksLabText_44229
	text_end

PokedexRatingText_4422e:
	text_far _OaksLabText_4422e
	text_end

PokedexRatingText_44233:
	text_far _OaksLabText_44233
	text_end

PokedexRatingText_44238:
	text_far _OaksLabText_44238
	text_end

PokedexRatingText_4423d:
	text_far _OaksLabText_4423d
	text_end

PokedexRatingText_44242:
	text_far _OaksLabText_44242
	text_end

PokedexRatingText_44247:
	text_far _OaksLabText_44247
	text_end

PokedexRatingText_4424c:
	text_far _OaksLabText_4424c
	text_end

DexSanityItems:
.Archipelago_Dexsanity_Items
    ds 151, $00

receivedDexItem:
	text "<PLAYER> received "
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

CheckMissingTrainersanity::
    ld hl, EventBattleTrainersanityDataStart
.loop
    ld a, [hli]
    cp $FF
    ret z
    ld e, a
    ld a, [hli]
    ld d, a
    ld a, [hli]
    ld c, a
    push hl
    ld h, d
    ld l, e
    ld b, FLAG_TEST
    predef FlagActionPredef
    ld a, c
	and a
	jr z, .trainernotbeaten
    pop hl
	ld bc, 4
	ld de, wEndBattleTrainersanityItem
	call CopyData
    push hl
    call CheckForTrainersanityItem
    pop hl
    jr .loop
.trainernotbeaten
    pop hl
    inc hl
    inc hl
    inc hl
    inc hl
    jr .loop

CheckAllDexSanity::
.Archipelago_Option_Dexsanity_A_1
    ld a, 0
    and a
    ret z
.Archipelago_Require_Pokedex_B_1
    ld a, 0
    and a
    jr z, .skipDexCheck
	CheckEvent EVENT_GOT_POKEDEX
	ret z
.skipDexCheck

    xor a
    ld c, 255

.loop
    inc c
    ld a, c
    cp 152
    ret z
    ld hl, wPokedexOwned
	ld b, FLAG_TEST
	push bc
	predef FlagActionPredef
	ld a, c
	pop bc
	and a
	jr z, .loop
    ld hl, wDexSanity
	ld b, FLAG_TEST
	push bc
	predef FlagActionPredef
	ld a, c
	pop bc
	and a
	jr nz, .loop
	ld b, 0
	ld hl, DexSanityItems
    add hl, bc
    push bc
    ld a, [hl]

    ; if item is 0 then don't give anything
    and a
    jr z, .nextLoop

    ld b, a
    ld c, 1

    call GiveItem
    jr nc, .bagFull
	ld hl, receivedDexItem
	call PrintText
	call WaitForTextScrollButtonPress

    pop bc
    push bc
	ld b, FLAG_SET
    ld hl, wDexSanity
	predef FlagActionPredef
.nextLoop
	pop bc
    jr .loop
.bagFull
    pop bc
    ret



registerDexSanity::
.Archipelago_Option_Dexsanity_B_1
    ld a, 0
    and a
    ret z
.Archipelago_Require_Pokedex_C_1
    ld a, 0
    and a
    jr z, .skipDexCheck
	CheckEvent EVENT_GOT_POKEDEX
	ret z
.skipDexCheck
	ld a, [wd11e]
	dec a
	ld c, a
	ld hl, wDexSanity
	ld b, FLAG_TEST
	push bc
	predef FlagActionPredef
	ld a, c
    and a
    jr z, .continue
    pop bc
    ret
.continue
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, 0
    ld hl, DexSanityItems
    add hl, bc
    ld a, [hl]

    and a
    jr z, .noItem

	ld b, a
	ld c, 1
    call GiveItem
    jr c, .bagNotFull
.noItem
    pop bc
    ret
.bagNotFull
    ld hl, receivedDexItem
    call PrintText
	call WaitForTextScrollButtonPress
    pop bc
    ld b, FLAG_SET
	ld hl, wDexSanity
	predef FlagActionPredef
	ret

wball:
    db "<wball>@"

DexSanityIconCheck::
    ld a, [wd11e]
    dec a
	ld c, a
	ld b, 0
	ld hl, DexSanityItems
	add hl, bc
    ld a, [hl]
    and a
    ret z
	hlcoord 1, 1
	ld de, wball
	jp PlaceString

DexSanityIconCheckPokedex::
    ld a, [wd11e]
    dec a
	ld c, a
	ld b, 0
	ld hl, DexSanityItems
	add hl, bc
    ld a, [hl]
    and a
    ret