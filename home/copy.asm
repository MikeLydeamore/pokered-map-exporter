FarCopyData::
; Copy bc bytes from a:hl to de.
	ld [wBuffer], a
	ldh a, [hLoadedROMBank]
	push af
	ld a, [wBuffer]
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	call CopyData
	pop af
	ldh [hLoadedROMBank], a
	ld [MBC1RomBank], a
	ret

CopyData::
; Copy bc bytes from hl to de.
    ;xor a
    ;ld [wArchipelagoGameStarted], a
    ;push bc
    ;push hl
    ;farcall crashtest
    ;pop hl
    ;pop bc
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, CopyData
    ;ld a, $2A
    ;ld [wArchipelagoGameStarted], a
	ret
