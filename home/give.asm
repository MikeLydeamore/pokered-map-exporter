GiveItem::
; Give player quantity c of item b,
; and copy the item's name to wStringBuffer.
; Return carry on success.
    ld a, b
    ld [wd11e], a
    ld [wcf91], a
	ld a, c
	ld [wItemQuantity], a
    farcall _GiveItem
    ret



SplitKeyChecks::
.Archipelago_Option_Split_Card_Key_0
db $0
FixCombatBugs::
.Archipelago_Option_Fix_Combat_Bugs_0
db $0
EventBattleTrainersanityDataStart::
    EventBattleTrainersanityData EVENT_BEAT_LAB_RIVAL_ITEM, EVENT_BATTLED_RIVAL_IN_OAKS_LAB
    EventBattleTrainersanityData EVENT_BEAT_CERULEAN_RIVAL_ITEM, EVENT_BEAT_CERULEAN_RIVAL
    EventBattleTrainersanityData EVENT_BEAT_SILPH_CO_GIOVANNI_ITEM, EVENT_BEAT_SILPH_CO_GIOVANNI
    EventBattleTrainersanityData EVENT_BEAT_CERULEAN_ROCKET_THIEF_ITEM, EVENT_BEAT_CERULEAN_ROCKET_THIEF
    EventBattleTrainersanityData EVENT_DEFEATED_FIGHTING_DOJO_ITEM, EVENT_DEFEATED_FIGHTING_DOJO
    EventBattleTrainersanityData EVENT_BEAT_GAME_CORNER_ROCKET_ITEM, EVENT_BEAT_GAME_CORNER_ROCKET
    EventBattleTrainersanityData EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD_ITEM, EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
    EventBattleTrainersanityData EVENT_BEAT_POKEMON_TOWER_RIVAL_ITEM, EVENT_BEAT_POKEMON_TOWER_RIVAL
    EventBattleTrainersanityData EVENT_BEAT_SILPH_CO_RIVAL_ITEM, EVENT_BEAT_SILPH_CO_RIVAL
    EventBattleTrainersanityData EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE_ITEM, EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
    EventBattleTrainersanityData EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE_ITEM, EVENT_BEAT_ROUTE22_RIVAL_2ND_BATTLE
    EventBattleTrainersanityData EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI_ITEM, EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
    EventBattleTrainersanityData EVENT_BEAT_ROUTE_24_LEADER_ITEM, EVENT_GOT_NUGGET
    EventBattleTrainersanityData EVENT_BEAT_RIVAL_SS_ANNE_ITEM, EVENT_BEAT_RIVAL_SS_ANNE
    db $FF

;BadgeList:
;db BOULDERBADGE
;db CASCADEBADGE
;db THUNDERBADGE
;db RAINBOWBADGE
;db SOULBADGE
;db MARSHBADGE
;db VOLCANOBADGE;
;db EARTHBADGE
;db $FF

GivePokemon::
; Give the player monster b at level c.
	ld a, b
	ld [wcf91], a
	ld a, c
	ld [wCurEnemyLVL], a
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	farjp _GivePokemon
