/datum/job/tegu/pilot_officer
	title = "Pilot Officer"
	department_head = list("Wing Commander")
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the wing commander"
	selection_color = "#884488"
	exp_requirements = 60
	exp_type = EXP_TYPE_CREW
	maptype = "syndicate"

	outfit = /datum/outfit/job/pilot_officer

	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_ENG
	liver_traits = list(TRAIT_ENGINEER_METABOLISM)
	display_order = JOB_DISPLAY_ORDER_SCIENTIST
	bounty_types = CIV_JOB_ENG

/datum/outfit/job/pilot_officer
	name = "Pilot Officer"
	jobtype = /datum/job/tegu/pilot_officer

	id = /obj/item/card/id/black
	ears = /obj/item/radio/headset/syndicate/alt/leader
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/space/syndicate/blue
	belt = null
	backpack_contents = list(/obj/item/clothing/head/helmet/space/syndicate/blue)



//Spawn Point
/obj/effect/landmark/start/pilot_officer
	name = "Pilot Officer"
	icon_state = "pilot_officer"
