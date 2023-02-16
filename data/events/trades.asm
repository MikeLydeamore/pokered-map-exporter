TradeMons:
; entries correspond to TRADE_FOR_* constants
	table_width 3 + NAME_LENGTH, TradeMons
	; give mon, get mon, dialog id, nickname
.Archipelago_Trade_Terry
	db NIDORINO,   NIDORINA,  TRADE_DIALOGSET_CASUAL, "TERRY@@@@@@"
.Archipelago_Trade_Marcel
	db ABRA,       MR_MIME,   TRADE_DIALOGSET_CASUAL, "MARCEL@@@@@"
	db BUTTERFREE, BEEDRILL,  TRADE_DIALOGSET_HAPPY,  "CHIKUCHIKU@"
.Archipelago_Trade_Sailor
	db PONYTA,     SEEL,      TRADE_DIALOGSET_CASUAL, "SAILOR@@@@@"
.Archipelago_Trade_Dux
	db SPEAROW,    FARFETCHD, TRADE_DIALOGSET_HAPPY,  "DUX@@@@@@@@"
.Archipelago_Trade_Marc
	db SLOWBRO,    LICKITUNG, TRADE_DIALOGSET_CASUAL, "MARC@@@@@@@"
.Archipelago_Trade_Lola
	db POLIWHIRL,  JYNX,      TRADE_DIALOGSET_POLITE, "LOLA@@@@@@@"
.Archipelago_Trade_Doris
	db RAICHU,     ELECTRODE, TRADE_DIALOGSET_POLITE, "DORIS@@@@@@"
.Archipelago_Trade_Crinkles
	db VENONAT,    TANGELA,   TRADE_DIALOGSET_HAPPY,  "CRINKLES@@@"
.Archipelago_Trade_Spot
	db NIDORAN_M,  NIDORAN_F, TRADE_DIALOGSET_HAPPY,  "SPOT@@@@@@@"
	assert_table_length NUM_NPC_TRADES
