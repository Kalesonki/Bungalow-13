 //Suits for the pink and grey skeletons! //EVA version no longer used in favor of the Jumpsuit version


/obj/item/clothing/suit/space/eva/plasmaman
	name = "EVA plasma envirosuit"
	desc = "A special plasma containment suit designed to be space-worthy, as well as worn over other clothing. Like its smaller counterpart, it can automatically extinguish the wearer in a crisis, and holds twice as many charges."
	allowed = list(/obj/item/gun, /obj/item/ammo_casing, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword, /obj/item/restraints/handcuffs, /obj/item/tank)
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 0, "fire" = 100, "acid" = 75)
	resistance_flags = FIRE_PROOF
	icon_state = "plasmaman_suit"
	inhand_icon_state = "plasmaman_suit"
	var/next_extinguish = 0
	var/extinguish_cooldown = 100
	var/extinguishes_left = 10


/obj/item/clothing/suit/space/eva/plasmaman/examine(mob/user)
	. = ..()
	. += "<span class='notice'>There [extinguishes_left == 1 ? "is" : "are"] [extinguishes_left] extinguisher charge\s left in this suit.</span>"


/obj/item/clothing/suit/space/eva/plasmaman/proc/Extinguish(mob/living/carbon/human/H)
	if(!istype(H))
		return

	if(H.fire_stacks)
		if(extinguishes_left)
			if(next_extinguish > world.time)
				return
			next_extinguish = world.time + extinguish_cooldown
			extinguishes_left--
			H.visible_message("<span class='warning'>[H]'s suit automatically extinguishes [H.p_them()]!</span>","<span class='warning'>Your suit automatically extinguishes you.</span>")
			H.ExtinguishMob()
			new /obj/effect/particle_effect/water(get_turf(H))


//I just want the light feature of the hardsuit helmet
/obj/item/clothing/head/helmet/space/plasmaman
	name = "plasma envirosuit helmet"
	desc = "A special containment helmet that allows plasma-based lifeforms to exist safely in an oxygenated environment. It is space-worthy, and may be worn in tandem with other EVA gear."
	icon_state = "plasmaman-helm"
	inhand_icon_state = "plasmaman-helm"
	strip_delay = 80
	flash_protect = FLASH_PROTECTION_WELDER
	tint = 2
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 0, "fire" = 100, "acid" = 75)
	resistance_flags = FIRE_PROOF
	var/brightness_on = 4 //luminosity when the light is on
	var/on = FALSE
	var/smile = FALSE
	var/smile_color = "#FF0000"
	var/visor_icon = "envisor"
	var/smile_state = "envirohelm_smile"
	actions_types = list(/datum/action/item_action/toggle_helmet_light, /datum/action/item_action/toggle_welding_screen/plasmaman)
	visor_vars_to_toggle = VISOR_FLASHPROTECT | VISOR_TINT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSMOUTH|HEADCOVERSEYES|PEPPERPROOF
	visor_flags_inv = HIDEEYES|HIDEFACE

/obj/item/clothing/head/helmet/space/plasmaman/Initialize()
	. = ..()
	visor_toggling()
	update_icon()

/obj/item/clothing/head/helmet/space/plasmaman/AltClick(mob/user)
	if(user.canUseTopic(src, BE_CLOSE))
		toggle_welding_screen(user)

/obj/item/clothing/head/helmet/space/plasmaman/proc/toggle_welding_screen(mob/living/user)
	if(weldingvisortoggle(user))
		if(on)
			to_chat(user, "<span class='notice'>Your helmet's torch can't pass through your welding visor!</span>")
			on = FALSE
			playsound(src, 'sound/mecha/mechmove03.ogg', 50, TRUE) //Visors don't just come from nothing
			update_icon()
		else
			playsound(src, 'sound/mecha/mechmove03.ogg', 50, TRUE) //Visors don't just come from nothing
			update_icon()

/obj/item/clothing/head/helmet/space/plasmaman/update_overlays()
	. = ..()
	. += visor_icon

/obj/item/clothing/head/helmet/space/plasmaman/attackby(obj/item/C, mob/living/user)
	. = ..()
	if(istype(C, /obj/item/toy/crayon))
		if(smile == FALSE)
			var/obj/item/toy/crayon/CR = C
			to_chat(user, "<span class='notice'>You start drawing a smiley face on the helmet's visor..</span>")
			if(do_after(user, 25, target = src))
				smile = TRUE
				smile_color = CR.paint_color
				to_chat(user, "You draw a smiley on the helmet visor.")
				update_icon()
		else
			to_chat(user, "<span class='warning'>Seems like someone already drew something on this helmet's visor!</span>")

/obj/item/clothing/head/helmet/space/plasmaman/worn_overlays(isinhands)
	. = ..()
	if(!isinhands && smile)
		var/mutable_appearance/M = mutable_appearance('icons/mob/clothing/head.dmi', smile_state)
		M.color = smile_color
		. += M
	if(!isinhands && !up)
		. += mutable_appearance('icons/mob/clothing/head.dmi', visor_icon)
	else
		cut_overlays()

/obj/item/clothing/head/helmet/space/plasmaman/wash(clean_types)
	. = ..()
	if(smile && (clean_types & CLEAN_TYPE_PAINT))
		smile = FALSE
		update_icon()
		return TRUE

/obj/item/clothing/head/helmet/space/plasmaman/attack_self(mob/user)
	on = !on
	icon_state = "[initial(icon_state)][on ? "-light":""]"
	inhand_icon_state = icon_state
	user.update_inv_head() //So the mob overlay updates

	if(on)
		if(!up)
			to_chat(user, "<span class='notice'>Your helmet's torch can't pass through your welding visor!</span>")
			set_light(0)
		else
			set_light(brightness_on)
	else
		set_light(0)

	for(var/X in actions)
		var/datum/action/A=X
		A.UpdateButtonIcon()

/obj/item/clothing/head/helmet/space/plasmaman/security
	name = "security plasma envirosuit helmet"
	desc = "A plasmaman containment helmet designed for security officers, protecting them from being flashed and burning alive, alongside other undesirables."
	icon_state = "security_envirohelm"
	inhand_icon_state = "security_envirohelm"
	armor = list("melee" = 10, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 0, "fire" = 100, "acid" = 75)

/obj/item/clothing/head/helmet/space/plasmaman/security/warden
	name = "warden's plasma envirosuit helmet"
	desc = "A plasmaman containment helmet designed for the warden, a pair of white stripes being added to differeciate them from other members of security."
	icon_state = "warden_envirohelm"
	inhand_icon_state = "warden_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/security/head_of_security
	name = "head of security's plasma envirosuit helmet"
	desc = "A special containment helmet designed for the Head of Security. A pair of gold stripes are added to differentiate them from other members of security."
	icon_state = "hos_envirohelm"
	inhand_icon_state = "hos_envirohelm"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10, "energy" = 10, "bomb" = 10, "bio" = 100, "rad" = 0, "fire" = 100, "acid" = 75, "wound" = 10)

/obj/item/clothing/head/helmet/space/plasmaman/prisoner
	name = "prisoner's plasma envirosuit helmet"
	desc = "A plasmaman containment helmet for prisoners."
	icon_state = "prisoner_envirohelm"
	inhand_icon_state = "prisoner_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/medical
	name = "medical doctor's plasma envirosuit helmet"
	desc = "An envirohelmet designed for plasmaman medical doctors, having two stripes down its length to denote as much."
	icon_state = "doctor_envirohelm"
	inhand_icon_state = "doctor_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/paramedic
	name = "paramedic plasma envirosuit helmet"
	desc = "An envirohelmet designed for plasmaman paramedics, with darker blue stripes compared to the medical model."
	icon_state = "paramedic_envirohelm"
	inhand_icon_state = "paramedic_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/viro
	name = "virology plasma envirosuit helmet"
	desc = "The helmet worn by the safest people on the station, those who are completely immune to the monstrosities they create."
	icon_state = "virologist_envirohelm"
	inhand_icon_state = "virologist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/chemist
	name = "chemistry plasma envirosuit helmet"
	desc = "A plasmaman envirosuit designed for chemists, two orange stripes going down it's face."
	icon_state = "chemist_envirohelm"
	inhand_icon_state = "chemist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/chief_medical_officer
	name = "chief medical officer's plasma envirosuit helmet"
	desc = "A special containment helmet designed for the Chief Medical Officer. A light grey design is applied to differentiate them from other medical staff."
	icon_state = "cmo_envirohelm"
	inhand_icon_state = "cmo_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/science
	name = "science plasma envirosuit helmet"
	desc = "A plasmaman envirohelmet designed for scientists."
	icon_state = "scientist_envirohelm"
	inhand_icon_state = "scientist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/robotics
	name = "robotics plasma envirosuit helmet"
	desc = "A plasmaman envirohelmet designed for roboticists."
	icon_state = "roboticist_envirohelm"
	inhand_icon_state = "roboticist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/genetics
	name = "geneticist's plasma envirosuit helmet"
	desc = "A plasmaman envirohelmet designed for geneticists."
	icon_state = "geneticist_envirohelm"
	inhand_icon_state = "geneticist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/research_director
	name = "research director plasma envirosuit helmet"
	desc = "A special containment helmet designed for the Research Director. A light brown design is applied to differentiate them from other scientists."
	icon_state = "rd_envirohelm"
	inhand_icon_state = "rd_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/engineering
	name = "engineering plasma envirosuit helmet"
	desc = "A space-worthy helmet specially designed for engineer plasmamen, the usual purple stripes being replaced by engineering's orange."
	icon_state = "engineer_envirohelm"
	inhand_icon_state = "engineer_envirohelm"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 10, "fire" = 100, "acid" = 75)

/obj/item/clothing/head/helmet/space/plasmaman/atmospherics
	name = "atmospherics plasma envirosuit helmet"
	desc = "A space-worthy helmet specially designed for atmos technician plasmamen, the usual purple stripes being replaced by engineering's blue."
	icon_state = "atmos_envirohelm"
	inhand_icon_state = "atmos_envirohelm"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 10, "fire" = 100, "acid" = 75)

/obj/item/clothing/head/helmet/space/plasmaman/chief_engineer
	name = "chief engineer plasma envirosuit helmet"
	desc = "A special containment helmet designed for the Chief Engineer. An expensive, element resistant white and green carapace design is applied to protect the plasmaman inside."
	icon_state = "ce_envirohelm"
	inhand_icon_state = "ce_envirohelm"
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 10, "fire" = 100, "acid" = 75)

/obj/item/clothing/head/helmet/space/plasmaman/cargo
	name = "cargo plasma envirosuit helmet"
	desc = "A plasmaman envirohelmet designed for cargo techs and quartermasters."
	icon_state = "cargo_envirohelm"
	inhand_icon_state = "cargo_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/mining
	name = "mining plasma envirosuit helmet"
	desc = "A khaki helmet given to plasmamen miners operating on lavaland."
	icon_state = "explorer_envirohelm"
	inhand_icon_state = "explorer_envirohelm"
	visor_icon = "explorer_envisor"

/obj/item/clothing/head/helmet/space/plasmaman/chaplain
	name = "chaplain's plasma envirosuit helmet"
	desc = "An envirohelmet specially designed for only the most pious of plasmamen."
	icon_state = "chap_envirohelm"
	inhand_icon_state = "chap_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/white
	name = "white plasma envirosuit helmet"
	desc = "A generic white envirohelm."
	icon_state = "white_envirohelm"
	inhand_icon_state = "white_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/curator
	name = "curator's plasma envirosuit helmet"
	desc = "A slight modification on a tradiational voidsuit helmet, this helmet was Nano-Trasen's first solution to the *logistical problems* that come with employing plasmamen. Despite their limitations, these helmets still see use by historian and old-styled plasmamen alike."
	icon_state = "prototype_envirohelm"
	inhand_icon_state = "prototype_envirohelm"
	actions_types = list(/datum/action/item_action/toggle_welding_screen/plasmaman)
	smile_state = "prototype_smile"
	visor_icon = "prototype_envisor"

/obj/item/clothing/head/helmet/space/plasmaman/botany
	name = "botany plasma envirosuit helmet"
	desc = "A green and blue envirohelmet designating it's wearer as a botanist. While not specially designed for it, it would protect against minor planet-related injuries."
	icon_state = "botany_envirohelm"
	inhand_icon_state = "botany_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/janitor
	name = "janitor's plasma envirosuit helmet"
	desc = "A grey helmet bearing a pair of purple stripes, designating the wearer as a janitor."
	icon_state = "janitor_envirohelm"
	inhand_icon_state = "janitor_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/mime
	name = "mime envirosuit helmet"
	desc = "The make-up is painted on, it's a miracle it doesn't chip. It's not very colourful."
	icon_state = "mime_envirohelm"
	inhand_icon_state = "mime_envirohelm"
	visor_icon = "mime_envisor"

/obj/item/clothing/head/helmet/space/plasmaman/clown
	name = "clown envirosuit helmet"
	desc = "The make-up is painted on, it's a miracle it doesn't chip. <i>'HONK!'</i>"
	icon_state = "clown_envirohelm"
	inhand_icon_state = "clown_envirohelm"
	visor_icon = "clown_envisor"
	smile_state = "clown_smile"

/obj/item/clothing/head/helmet/space/plasmaman/head_of_personnel
	name = "head of personnel envirosuit helmet"
	desc = "A special containment helmet designed for the Head of Personnel. Embarrassingly enough, it looks way too much like the captain's design save for the red stripes."
	icon_state = "hop_envirohelm"
	inhand_icon_state = "hop_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/captain
	name = "captain's plasma envirosuit helmet"
	desc = "A special containment helmet designed for the Captain. Embarrassingly enough, it looks way too much like the hop's design save for the gold stripes. I mean, come on. Gold stripes can fix anything."
	icon_state = "captain_envirohelm"
	inhand_icon_state = "captain_envirohelm"
	armor = list("melee" = 20, "bullet" = 10, "laser" = 10, "energy" = 10, "bomb" = 10, "bio" = 100, "rad" = 0, "fire" = 100, "acid" = 75, "wound" = 10)

/obj/item/clothing/head/helmet/space/plasmaman/centcom_commander
	name = "centom plasma envirosuit helmet"
	desc = "A special containment helmet designed for the Higher Centcom Command Staff. Not many of these exist, as Centcom does not usually employ plasmamen to higher staff positions due to their complications."
	icon_state = "commander_envirohelm"
	inhand_icon_state = "commander_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/centcom_official
	name = "centom official plasma envirosuit helmet"
	desc = "A plasmaman envirohelm designed for Centcom Officials."
	icon_state = "official_envirohelm"
	inhand_icon_state = "official_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/centcom_intern
	name = "centom interns plasma envirosuit helmet"
	desc = "A plasmaman envirohelm designed for Centcom Interns."
	icon_state = "intern_envirohelm"
	inhand_icon_state = "intern_envirohelm"
