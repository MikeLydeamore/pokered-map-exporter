Route22Gate_Object:
	db $a ; border block

	def_warp_events
	warp_event  4,  7, ROUTE_22, 1
	warp_event  5,  7, ROUTE_22, 1
	warp_event  4,  0, ROUTE_23, 1
	warp_event  5,  0, ROUTE_23, 2

	def_bg_events

	def_object_events
	object_event  6,  2, SPRITE_GUARD, STAY, LEFT, 1 ; person

	def_warps_to ROUTE_22_GATE
