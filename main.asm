INCLUDE "constants.asm"


SECTION "bank1", ROMX

INCLUDE "data/sprites/facings.asm"
INCLUDE "engine/events/black_out.asm"
INCLUDE "data/pokemon/mew.asm"
INCLUDE "engine/battle/safari_zone.asm"
INCLUDE "engine/movie/title.asm"
INCLUDE "engine/pokemon/load_mon_data.asm"
INCLUDE "data/items/prices.asm"
INCLUDE "data/items/names.asm"
INCLUDE "data/text/unused_names.asm"
INCLUDE "engine/gfx/sprite_oam.asm"
INCLUDE "engine/gfx/oam_dma.asm"
INCLUDE "engine/link/print_waiting_text.asm"
INCLUDE "engine/overworld/sprite_collisions.asm"
INCLUDE "engine/debug/debug_menu.asm"
INCLUDE "engine/events/pick_up_item.asm"
INCLUDE "engine/overworld/movement.asm"
INCLUDE "engine/link/cable_club.asm"
INCLUDE "engine/menus/main_menu.asm"
INCLUDE "engine/movie/oak_speech/oak_speech.asm"
INCLUDE "engine/overworld/special_warps.asm"
INCLUDE "engine/debug/debug_party.asm"
INCLUDE "engine/menus/naming_screen.asm"
INCLUDE "engine/movie/oak_speech/oak_speech2.asm"
INCLUDE "engine/items/subtract_paid_money.asm"
INCLUDE "engine/menus/swap_items.asm"
INCLUDE "engine/events/pokemart.asm"
INCLUDE "engine/pokemon/learn_move.asm"
INCLUDE "engine/events/pokecenter.asm"
INCLUDE "engine/events/set_blackout_map.asm"
INCLUDE "engine/menus/display_text_id_init.asm"
INCLUDE "engine/menus/draw_start_menu.asm"
INCLUDE "engine/link/cable_club_npc.asm"
INCLUDE "engine/menus/text_box.asm"
INCLUDE "engine/battle/move_effects/drain_hp.asm"
INCLUDE "engine/menus/players_pc.asm"
INCLUDE "engine/pokemon/remove_mon.asm"
INCLUDE "engine/events/display_pokedex.asm"


SECTION "bank3", ROMX

INCLUDE "engine/joypad.asm"
INCLUDE "data/maps/songs.asm"
INCLUDE "data/maps/map_header_banks.asm"
INCLUDE "engine/overworld/clear_variables.asm"
INCLUDE "engine/overworld/player_state.asm"
INCLUDE "engine/events/poison.asm"
INCLUDE "engine/overworld/tilesets.asm"
INCLUDE "engine/overworld/daycare_exp.asm"
INCLUDE "data/maps/hide_show_data.asm"
INCLUDE "engine/overworld/field_move_messages.asm"
INCLUDE "engine/items/inventory.asm"
INCLUDE "engine/overworld/wild_mons.asm"
INCLUDE "engine/items/item_effects.asm"
INCLUDE "engine/menus/draw_badges.asm"
INCLUDE "engine/overworld/update_map.asm"
INCLUDE "engine/overworld/cut.asm"
INCLUDE "engine/overworld/missable_objects.asm"
INCLUDE "engine/overworld/push_boulder.asm"
INCLUDE "engine/pokemon/add_mon.asm"
INCLUDE "engine/flag_action.asm"
INCLUDE "engine/events/heal_party.asm"
INCLUDE "engine/math/bcd.asm"
INCLUDE "engine/movie/oak_speech/init_player_data.asm"
INCLUDE "engine/items/get_bag_item_quantity.asm"
INCLUDE "engine/overworld/pathfinding.asm"
INCLUDE "engine/gfx/hp_bar.asm"
INCLUDE "engine/events/hidden_objects/bookshelves.asm"
INCLUDE "engine/events/hidden_objects/indigo_plateau_statues.asm"
INCLUDE "engine/events/hidden_objects/book_or_sculpture.asm"
INCLUDE "engine/events/hidden_objects/elevator.asm"
INCLUDE "engine/events/hidden_objects/town_map.asm"
INCLUDE "engine/events/hidden_objects/pokemon_stuff.asm"


SECTION "Font Graphics", ROMX

INCLUDE "gfx/font.asm"


SECTION "Battle Engine 1", ROMX

INCLUDE "engine/overworld/is_player_just_outside_map.asm"
INCLUDE "engine/pokemon/status_screen.asm"
INCLUDE "engine/menus/party_menu.asm"
INCLUDE "gfx/player.asm"
INCLUDE "engine/overworld/turn_sprite.asm"
INCLUDE "engine/menus/start_sub_menus.asm"
INCLUDE "engine/items/tms.asm"
INCLUDE "engine/battle/end_of_battle.asm"
INCLUDE "engine/battle/wild_encounters.asm"
INCLUDE "engine/battle/move_effects/recoil.asm"
INCLUDE "engine/battle/move_effects/conversion.asm"
INCLUDE "engine/battle/move_effects/haze.asm"
INCLUDE "engine/battle/get_trainer_name.asm"
INCLUDE "engine/math/random.asm"


SECTION "Battle Engine 2", ROMX

INCLUDE "engine/gfx/load_pokedex_tiles.asm"
INCLUDE "engine/overworld/map_sprites.asm"
INCLUDE "engine/overworld/emotion_bubbles.asm"
INCLUDE "engine/events/evolve_trade.asm"
INCLUDE "engine/battle/move_effects/substitute.asm"
INCLUDE "engine/menus/pc.asm"


SECTION "Play Time", ROMX

INCLUDE "engine/play_time.asm"


SECTION "Doors and Ledges", ROMX

INCLUDE "engine/overworld/auto_movement.asm"
INCLUDE "engine/overworld/doors.asm"
INCLUDE "engine/overworld/ledges.asm"


SECTION "Pokémon Names", ROMX

INCLUDE "data/pokemon/names.asm"
INCLUDE "engine/movie/oak_speech/clear_save.asm"
INCLUDE "engine/events/elevator.asm"


SECTION "Hidden Objects 1", ROMX

INCLUDE "engine/menus/oaks_pc.asm"
INCLUDE "engine/events/hidden_objects/new_bike.asm"
INCLUDE "engine/events/hidden_objects/oaks_lab_posters.asm"
INCLUDE "engine/events/hidden_objects/safari_game.asm"
INCLUDE "engine/events/hidden_objects/cinnabar_gym_quiz.asm"
INCLUDE "engine/events/hidden_objects/magazines.asm"
INCLUDE "engine/events/hidden_objects/bills_house_pc.asm"
INCLUDE "engine/events/hidden_objects/oaks_lab_email.asm"


SECTION "Bill's PC", ROMX

INCLUDE "engine/pokemon/bills_pc.asm"


SECTION "Battle Engine 3", ROMX

INCLUDE "engine/battle/print_type.asm"
INCLUDE "engine/battle/save_trainer_name.asm"
INCLUDE "engine/battle/move_effects/focus_energy.asm"


SECTION "Battle Engine 4", ROMX

INCLUDE "engine/battle/move_effects/leech_seed.asm"


SECTION "Battle Engine 5", ROMX

INCLUDE "engine/battle/display_effectiveness.asm"
INCLUDE "gfx/trainer_card.asm"
INCLUDE "engine/items/tmhm.asm"
INCLUDE "engine/battle/scale_sprites.asm"
INCLUDE "engine/battle/move_effects/pay_day.asm"
INCLUDE "engine/slots/game_corner_slots2.asm"


SECTION "Battle Engine 6", ROMX

INCLUDE "engine/battle/move_effects/mist.asm"
INCLUDE "engine/battle/move_effects/one_hit_ko.asm"


SECTION "Slot Machines", ROMX

INCLUDE "engine/movie/title2.asm"
INCLUDE "engine/battle/link_battle_versus_text.asm"
INCLUDE "engine/slots/slot_machine.asm"
INCLUDE "engine/events/pewter_guys.asm"
INCLUDE "engine/math/multiply_divide.asm"
INCLUDE "engine/slots/game_corner_slots.asm"


SECTION "Battle Engine 7", ROMX

INCLUDE "data/moves/moves.asm"
INCLUDE "data/pokemon/base_stats.asm"
INCLUDE "data/pokemon/cries.asm"
INCLUDE "engine/battle/unused_stats_functions.asm"
INCLUDE "engine/battle/scroll_draw_trainer_pic.asm"
INCLUDE "engine/battle/trainer_ai.asm"
INCLUDE "engine/battle/draw_hud_pokeball_gfx.asm"
INCLUDE "gfx/trade.asm"
INCLUDE "engine/pokemon/evos_moves.asm"
INCLUDE "engine/battle/move_effects/heal.asm"
INCLUDE "engine/battle/move_effects/transform.asm"
INCLUDE "engine/battle/move_effects/reflect_light_screen.asm"


SECTION "Battle Core", ROMX

INCLUDE "engine/battle/core.asm"
INCLUDE "engine/battle/effects.asm"


SECTION "bank10", ROMX

INCLUDE "engine/menus/pokedex.asm"
INCLUDE "engine/movie/trade.asm"
INCLUDE "engine/movie/intro.asm"
INCLUDE "engine/movie/trade2.asm"


SECTION "Pokédex Rating", ROMX

INCLUDE "engine/events/pokedex_rating.asm"
INCLUDE "engine/events/give_pokemon.asm"


SECTION "Hidden Objects Core", ROMX

INCLUDE "engine/overworld/hidden_objects.asm"


SECTION "Screen Effects", ROMX

INCLUDE "engine/gfx/screen_effects.asm"


SECTION "Predefs", ROMX

INCLUDE "engine/predefs.asm"


SECTION "Battle Engine 8", ROMX

INCLUDE "engine/battle/init_battle_variables.asm"
INCLUDE "engine/battle/move_effects/paralyze.asm"


SECTION "Hidden Objects 2", ROMX

INCLUDE "engine/events/card_key.asm"
INCLUDE "engine/events/prize_menu.asm"
INCLUDE "engine/events/hidden_objects/school_notebooks.asm"
INCLUDE "engine/events/hidden_objects/fighting_dojo.asm"
INCLUDE "engine/events/hidden_objects/indigo_plateau_hq.asm"


checkDeathLink_::
	ld a, [wArchipelagoDeathLink]
	cp 1
	ret nz
	ld a, 0
	ld [wPartyMon1HP], a
	ld [wPartyMon2HP], a
	ld [wPartyMon3HP], a
	ld [wPartyMon4HP], a
	ld [wPartyMon5HP], a
	ld [wPartyMon6HP], a
	ld [wPartyMon1HP + 1], a
	ld [wPartyMon2HP + 1], a
	ld [wPartyMon3HP + 1], a
	ld [wPartyMon4HP + 1], a
	ld [wPartyMon5HP + 1], a
	ld [wPartyMon6HP + 1], a
	ld [wBattleMonHP], a
	ld [wBattleMonHP + 1], a
	ret

	;ld a, 2
	;ld [wArchipelagoDeathLink], a
	;ld a, [wIsInBattle]
	;and a
	;ret z
    ;jp HandlePlayerMonFainted
	;ld a, [wBattleMonHP]
	;ld [wHPBarOldHP], a
	;ld a, [wBattleMonHP + 1]
	;ld [wHPBarOldHP + 1], a

	;ld a, 0
	;ld [wBattleMonHP], a
	;ld [wBattleMonHP + 1], a
	;ld [wHPBarNewHP], a
	;ld [wHPBarNewHP + 1], a
	;ld a,0
	;ldh [hWhoseTurn], a
	;farcall UpdateCurMonHPBar

	;predef DrawPlayerHUDAndHPBar

receiveArchipelagoItem_::

.noDeathLink
	ld a, [wArchipelagoItemReceived]
	cp $00
	ret z
    push bc
	ld b, a
	ld a, 1
	ld c, a
	call GiveItem
	jr nc, .bagFull
	ld a, [wArchipelagoItemsReceivedCount]
	ld c, a
	ld a, [wArchipelagoItemsReceivedCount+1]
	ld b, a
	inc bc
	ld a, c
	ld [wArchipelagoItemsReceivedCount], a
	ld a, b
	ld [wArchipelagoItemsReceivedCount+1], a
	ld a, $00
	ld [wArchipelagoItemReceived], a
	;push hl
	;hlcoord 0, 12
	;ld b, $04
	;ld c, $12
	;call TextBoxBorder
	;ld hl, ReceivedArchipelagoItemText
	;call justprinttext
	;ld a, MESSAGE_BOX
	;call DisplayTextBoxID
	;ld hl, ReceivedArchipelagoItemText
	;call PrintText
	;jp PrintText
	;pop hl
	;jp AfterDisplayingTextID
	;call EnableAutoTextBoxDrawing
	;tx_pre UnusedBenchGuyText1
	ld a, SFX_GET_ITEM_1
	call PlaySound
	;ld a, TEXT_RECEIVED_ITEM
	;ldh [hSpriteIndexOrTextID], a
	;call EnableAutoTextBoxDrawing
	;call DisplayTextID
.bagFull
	pop bc
	ret


FillStartInventory::
    ld hl, StartInventoryTable + 254
    ld b, 255
.loop
    ld a, [hld]
    dec b
    ret z
    and a
    jr z, .loop
    ld c, a
    push hl
    push bc
    ;ld a, c
    ;ld [wItemQuantity], a
    ;ld a, b
    ;ld [wcf91], a
    ;ld hl, wNumBagItems
    ;call AddItemToInventory
    call GiveItem
    pop bc
    pop hl
    jr .loop

StartInventoryTable:
.Archipelago_Start_Inventory_0
    DS 256, $00

ParalyzeTrap::
    ld a, (1 << PAR)
    call ApplyTrap
    ld a, [wIsInBattle]
    and a
    ret z
    farcall QuarterSpeedDueToParalysis
    ret
IceTrap::
    ld a, (1 << FRZ)
    jr ApplyTrap
FireTrap::
    ld a, (1 << BRN)
    call ApplyTrap
    ld a, [wIsInBattle]
    and a
    ret z
    farcall HalveAttackDueToBurn
    ret
PoisonTrap::
    ld a, (1 << PSN)
    jr ApplyTrap
SleepTrap::
	call Random
	and $7
	jr z, SleepTrap
	jr ApplyTrap

MACRO applytrap
    ld a, [\1HP]
    and a
    jr nz, .\1apply
    ld a, [\1HP + 1]
    and a
    jr z, .\1skip
.\1apply
    ld a, b
    ld [\1Status], a
.\1skip
ENDM

ApplyTrap:
    ld b, a
    applytrap wBattleMon
    applytrap wPartyMon1
    applytrap wPartyMon2
    applytrap wPartyMon3
    applytrap wPartyMon4
    applytrap wPartyMon5
    applytrap wPartyMon6
    ret

TenCoins::
    ld a, $10
	ldh [hCoins + 1], a
    jr addCoins
TwentyCoins::
    ld a, $20
	ldh [hCoins + 1], a
    jr addCoins
HundredCoins::
    ld a, $00
	ldh [hCoins + 1], a
    ld a, $01
	ldh [hCoins], a
	jr addCoins2
addCoins:
    xor a
	ldh [hCoins], a
addCoins2:
    xor a
	ldh [hUnusedCoinsByte], a
	ld de, wPlayerCoins + 1
	ld hl, hCoins + 1
	ld c, $2
	predef AddBCDPredef
	ret



;crashtest::
;    ld a, [wArchipelagoGameStarted]
;    and a
;    ret z
;    ld a, d
;    cp $d7
;    jr nz, .notEventFlags
;    ld a, e
;    cp $35
;    jr nz, .notEventFlags
;    stop
;.notEventFlags
;    ld a, d
;    cp $d6
;    jr nz, .notMissables
;    ld a, e
;    cp $1a
;    jr nz, .notMissables
;    stop
;.notMissables
;    ld a, d
;    cp $d7
;    jr nz, .notRod
;    ld a, e
;    cp $16
;    jr nz, .notRod
;    stop
;.notRod
;    ld a, d
;    cp $D1
;    jr nz, .notDex
;    ld a, e
;    cp $7a
;    jr nz, .notDex
;    stop
;.notDex
;    ld a, d
;    cp $D6
;    jr nz, .notHidden
;    ld a, e
;    cp $DE
;    jr nz, .notHidden
;    stop
;.notHidden
;    ret
_GiveItem::
    ld a, [wcf91]
    ld c, a
    ld a, [wd11e]
    ld b, a
    ld [wcf91], a

    cp AP_ITEM
    jp z, .apitem
    cp PROGRESSIVE_CARD_KEY
    jr nz, .noProgCardKey
    ld a, [wArchipelagoProgressiveKeys]
    inc a
    ld [wArchipelagoProgressiveKeys], a
    add CARD_KEY_2F - 1
    ld c, a
    ld [wcf91], a
    ld [wd11e], a
    jp .continue
.noProgCardKey
    cp TOWN_MAP
    jr nz, .noTownMap
.Archipelago_Map_Fly_Location_1
	ld a, $00
	ld c, a
	ld b, FLAG_SET
	ld hl, wTownVisitedFlag   ; mark town as visited (for flying)
	predef FlagActionPredef
	jp .continue
.noTownMap
    cp TEN_COINS
    jr nz, .no10coins
    farcall TenCoins
    jp .apitem
.no10coins
    cp TWENTY_COINS
    jr nz, .no20coins
    farcall TwentyCoins
    jr .apitem
.no20coins
    cp HUNDRED_COINS
    jr nz, .no100coins
    farcall HundredCoins
    jr .apitem
.no100coins
    cp POKEDEX
    jr nz, .nopokedex
    SetEvent EVENT_GOT_POKEDEX
    jr .apitem
.nopokedex
    cp POISON_TRAP
    jr nz, .nopoisontrap
    farcall PoisonTrap
    jr .apitem
.nopoisontrap
    cp PARALYZE_TRAP
    jr nz, .noparalyzetrap
    farcall ParalyzeTrap
    jr .apitem
.noparalyzetrap
    cp FIRE_TRAP
    jr nz, .nofiretrap
    farcall FireTrap
    jr .apitem
.nofiretrap
    CP ICE_TRAP
    jr nz, .noicetrap
    farcall IceTrap
    jr .apitem
.noicetrap
    cp SLEEP_TRAP
    jr nz, .nosleeptrap
    farcall SleepTrap
    jr .apitem
.nosleeptrap
    ;ld hl, BadgeList
    ;ld a, hli
    ld a, BOULDERBADGE - 1
.loop1
    cp EARTHBADGE
    jr z, .continue
    inc a
    cp b
    jr nz, .loop1
; match found
    ld c, 1
    ld a, b
    sub a, BOULDERBADGE
    ;ld b, a
    jr .skipsla
.loop2
    SLA c
    dec a
.skipsla
    cp 0
    jr nz, .loop2
    ld a, [wObtainedBadges]
    or c
    ld [wObtainedBadges], a
    jr .apitem
.continue
	ld a, c
	ld [wItemQuantity], a
	ld hl, wNumBagItems
	call AddItemToInventory
	ret nc
.apitem
	call GetItemName
	call CopyToStringBuffer
	scf
	ret

MACRO ResetBattle
.Archipelago_Reset_\4_1
    ld a, \1
    ld [wd11e], a
    predef IndexToPokedex
    ld a, [wd11e]
    dec a
    ld c, a
	ld b, FLAG_TEST
	ld hl, wPokedexOwned
	predef FlagActionPredef
	ld a, c
	and a
	jr nz, .noReset\4
	ResetEvent \2
	ld a, \3
	ld [wMissableObjectIndex], a
	predef ShowObject
.noReset\4
ENDM

ResetStaticPokemon::
    ResetBattle SNORLAX, EVENT_BEAT_ROUTE12_SNORLAX, HS_ROUTE_12_SNORLAX, A
    ResetBattle SNORLAX, EVENT_BEAT_ROUTE16_SNORLAX, HS_ROUTE_16_SNORLAX, B
    ResetBattle VOLTORB, EVENT_BEAT_POWER_PLANT_VOLTORB_0, HS_VOLTORB_1, C
    ResetBattle VOLTORB, EVENT_BEAT_POWER_PLANT_VOLTORB_1, HS_VOLTORB_2, D
    ResetBattle VOLTORB, EVENT_BEAT_POWER_PLANT_VOLTORB_2, HS_VOLTORB_3, E
    ResetBattle ELECTRODE, EVENT_BEAT_POWER_PLANT_VOLTORB_3, HS_ELECTRODE_1, F
    ResetBattle VOLTORB, EVENT_BEAT_POWER_PLANT_VOLTORB_4, HS_VOLTORB_4, G
    ResetBattle VOLTORB, EVENT_BEAT_POWER_PLANT_VOLTORB_5, HS_VOLTORB_5, H
    ResetBattle ELECTRODE, EVENT_BEAT_POWER_PLANT_VOLTORB_6, HS_ELECTRODE_2, I
    ResetBattle VOLTORB, EVENT_BEAT_POWER_PLANT_VOLTORB_7, HS_VOLTORB_6, J
    ResetBattle ZAPDOS, EVENT_BEAT_ZAPDOS, HS_ZAPDOS, K
    ResetBattle ARTICUNO, EVENT_BEAT_ARTICUNO, HS_ARTICUNO, L
    ResetBattle MOLTRES, EVENT_BEAT_MOLTRES, HS_MOLTRES, M
    ResetBattle MEWTWO, EVENT_BEAT_MEWTWO, HS_MEWTWO, N
    ResetBattle MEW, EVENT_BEAT_MEW, HS_MEW, O
    ret

SECTION "Battle Engine 9", ROMX

INCLUDE "engine/battle/experience.asm"


SECTION "Diploma", ROMX

INCLUDE "engine/events/diploma.asm"


SECTION "Trainer Sight", ROMX

INCLUDE "engine/overworld/trainer_sight.asm"


SECTION "Battle Engine 10", ROMX

INCLUDE "engine/battle/common_text.asm"
INCLUDE "engine/pokemon/experience.asm"
INCLUDE "engine/events/oaks_aide.asm"


SECTION "Saffron Guards", ROMX

INCLUDE "engine/events/saffron_guards.asm"


SECTION "Starter Dex", ROMX

INCLUDE "engine/events/starter_dex.asm"


SECTION "Hidden Objects 3", ROMX

INCLUDE "engine/pokemon/set_types.asm"
INCLUDE "engine/events/hidden_objects/reds_room.asm"
INCLUDE "engine/events/hidden_objects/route_15_binoculars.asm"
INCLUDE "engine/events/hidden_objects/museum_fossils.asm"
INCLUDE "engine/events/hidden_objects/school_blackboard.asm"
INCLUDE "engine/events/hidden_objects/vermilion_gym_trash.asm"


SECTION "Cinnabar Lab Fossils", ROMX

INCLUDE "engine/events/cinnabar_lab.asm"


SECTION "Hidden Objects 4", ROMX

INCLUDE "engine/events/hidden_objects/gym_statues.asm"
INCLUDE "engine/events/hidden_objects/bench_guys.asm"
INCLUDE "engine/events/hidden_objects/blues_room.asm"
INCLUDE "engine/events/hidden_objects/pokecenter_pc.asm"


SECTION "Battle Engine 11", ROMX

INCLUDE "engine/battle/decrement_pp.asm"
INCLUDE "gfx/version.asm"


SECTION "bank1C", ROMX

INCLUDE "engine/movie/splash.asm"
INCLUDE "engine/movie/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/items/town_map.asm"
INCLUDE "engine/gfx/mon_icons.asm"
INCLUDE "engine/events/in_game_trades.asm"
INCLUDE "engine/gfx/palettes.asm"
INCLUDE "engine/menus/save.asm"


SECTION "Itemfinder 1", ROMX

INCLUDE "engine/movie/credits.asm"
INCLUDE "engine/pokemon/status_ailments.asm"
INCLUDE "engine/items/itemfinder.asm"


SECTION "Vending Machine", ROMX

INCLUDE "engine/events/vending_machine.asm"


SECTION "Itemfinder 2", ROMX

INCLUDE "engine/menus/league_pc.asm"
INCLUDE "engine/events/hidden_items.asm"


SECTION "bank1E", ROMX

INCLUDE "engine/battle/animations.asm"
INCLUDE "engine/overworld/cut2.asm"
INCLUDE "engine/overworld/dust_smoke.asm"
INCLUDE "gfx/fishing.asm"
INCLUDE "data/moves/animations.asm"
INCLUDE "data/battle_anims/subanimations.asm"
INCLUDE "data/battle_anims/frame_blocks.asm"
INCLUDE "engine/movie/evolution.asm"
INCLUDE "engine/overworld/elevator.asm"
INCLUDE "engine/items/tm_prices.asm"
