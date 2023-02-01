PrizeDifferentMenuPtrs:
	dw PrizeMenuMon1Entries, PrizeMenuMon1Cost
	dw PrizeMenuMon2Entries, PrizeMenuMon2Cost
	dw PrizeMenuTMsEntries,  PrizeMenuTMsCost

NoThanksText:
	db "NO THANKS@"

PrizeMenuMon1Entries:
.Archipelago_Prize_Mon_A2
	db ABRA
.Archipelago_Prize_Mon_B2
	db CLEFAIRY
IF DEF(_RED)
.Archipelago_Prize_Mon_C2
	db NIDORINA
ENDC
IF DEF(_BLUE)
.Archipelago_Prize_Mon_C2
	db NIDORINO
ENDC
	db "@"

PrizeMenuMon1Cost:
IF DEF(_RED)
	bcd2 180
	bcd2 500
ENDC
IF DEF(_BLUE)
	bcd2 120
	bcd2 750
ENDC
	bcd2 1200
	db "@"

PrizeMenuMon2Entries:
IF DEF(_RED)
.Archipelago_Prize_Mon_D2
	db DRATINI
.Archipelago_Prize_Mon_E2
	db SCYTHER
ENDC
IF DEF(_BLUE)
.Archipelago_Prize_Mon_D2
	db PINSIR
.Archipelago_Prize_Mon_E2
	db DRATINI
ENDC
.Archipelago_Prize_Mon_F2
	db PORYGON
	db "@"

PrizeMenuMon2Cost:
IF DEF(_RED)
	bcd2 2800
	bcd2 5500
	bcd2 9999
ENDC
IF DEF(_BLUE)
	bcd2 2500
	bcd2 4600
	bcd2 6500
ENDC
	db "@"

PrizeMenuTMsEntries:
.Archipelago_Prize_Item_A_0
	db TM_DRAGON_RAGE
.Archipelago_Prize_Item_B_0
	db TM_HYPER_BEAM
.Archipelago_Prize_Item_C_0
	db TM_SUBSTITUTE
	db "@"

PrizeMenuTMsCost:
	bcd2 3300
	bcd2 5500
	bcd2 7700
	db "@"
