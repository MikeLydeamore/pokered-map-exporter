; TypeNames indexes (see data/types/names.asm)
	const_def

DEF PHYSICAL EQU const_value
	const NORMAL       ; $00    mewmon
	const FIGHTING     ; $01    earthy red
	const FLYING       ; $02    earthy yellow
	const POISON       ; $03    PAL_0F
	const GROUND       ; $04    brown
	const ROCK         ; $05    greymon
	const BIRD         ; $06
	const BUG          ; $07    PAL_BADGE
	const GHOST        ; $08    purple
	const STRUGGLE_TYPE; $09

	const_next 20

DEF SPECIAL EQU const_value
	const FIRE         ; $14    red
	const WATER        ; $15    cyan
	const GRASS        ; $16    green
	const ELECTRIC     ; $17    yellow
	const PSYCHIC_TYPE ; $18    pink
	const ICE          ; $19    blue
	const DRAGON       ; $1A    earthy green

DEF NUM_TYPES EQU const_value
