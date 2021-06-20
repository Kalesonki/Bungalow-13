/datum/job/tegu/triage_technician
	title = "Triage Technician"
	department_head = list("Medical Officer")
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the medical officer"
	selection_color = "#338800"
	exp_requirements = 60
	exp_type = EXP_TYPE_TRIAGE
	maptype = "syndicate"

	outfit = /datum/outfit/job/triage_technician

	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED
	liver_traits = list(TRAIT_ENGINEER_METABOLISM)
	display_order = JOB_DISPLAY_ORDER_MEDICAL_DOCTOR
	bounty_types = CIV_JOB_ENG

/datum/outfit/job/triage_technician
	name = "Triage Technician"
	jobtype = /datum/job/tegu/triage_technician
	belt = null

	id = /obj/item/card/id/black
	ears = /obj/item/radio/headset/syndicate
	uniform = /obj/item/clothing/under/syndicate
	glasses = /obj/item/clothing/glasses/hud/health/syndicate
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/latex
	suit = /obj/item/clothing/suit/armor/labcoat/syndie
	l_pocket = /obj/item/gun/ballistic/automatic/pistol



//Spawn Point
/obj/effect/landmark/start/triage_technician
	name = "Triage Technician"
	icon_state = "Triage Technician"
