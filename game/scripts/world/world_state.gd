class_name WorldState
extends RefCounted

const HeroCatalogScript = preload("res://scripts/characters/hero_catalog.gd")

## Small persistent domain model for the exploration POC.
## It deliberately contains no rendering or scene dependencies so it can later
## be replaced by an authoritative online profile service.

const START_POSITION := Vector2(470.0, 580.0)
const BERRY_IDS := ["berry_north", "berry_south", "berry_east"]
const QUEST_NOT_STARTED := "not_started"
const QUEST_COLLECT := "collect"
const QUEST_HUNT := "hunt"
const QUEST_RETURN := "return"
const QUEST_COMPLETE := "complete"

var player_position := START_POSITION
var hero_class_id := ""
var leaf_coins := 12
var experience := 0
var glow_berries := 0
var energy := 5
var quest_stage := QUEST_NOT_STARTED
var collected_berries: Array[String] = []
var defeated_encounters: Array[String] = []
var decorations: Array[String] = []


func get_level() -> int:
	return 1 + int(experience / 100)


func choose_hero(hero_id: String) -> Dictionary:
	if not HeroCatalogScript.is_valid(hero_id):
		return _failure("Cette classe n'est pas disponible.")
	hero_class_id = hero_id
	return _success("Héros créé", "%s rejoint WILDBOUND." % HeroCatalogScript.get_display_name(hero_id))


func get_hero_display_name() -> String:
	return HeroCatalogScript.get_display_name(hero_class_id)


func get_quest_title() -> String:
	return "First Bloom"


func get_objective_text() -> String:
	match quest_stage:
		QUEST_NOT_STARTED:
			return "Parlez à Owl Sage près du grand arbre."
		QUEST_COLLECT:
			return "Récoltez 3 Glow Berries (%d/3)." % collected_berries.size()
		QUEST_HUNT:
			return "Affrontez Moss Slime dans la clairière."
		QUEST_RETURN:
			return "Retournez voir Owl Sage."
		QUEST_COMPLETE:
			return "Quête terminée · Explorez, échangez et décorez."
	return "Explorez Whispering Woods."


func interact_with_sage() -> Dictionary:
	match quest_stage:
		QUEST_NOT_STARTED:
			quest_stage = QUEST_HUNT if collected_berries.size() >= 3 else QUEST_COLLECT
			return _success("Owl Sage", "Bienvenue, %s. Rassemble 3 Glow Berries, puis apaise Moss Slime." % get_hero_display_name())
		QUEST_COLLECT:
			return _success("Owl Sage", "Les Glow Berries brillent près des anciens chemins. Il en faut encore %d." % max(0, 3 - collected_berries.size()))
		QUEST_HUNT:
			return _success("Owl Sage", "La clairière t'attend. Approche Moss Slime quand tu es prêt.")
		QUEST_RETURN:
			quest_stage = QUEST_COMPLETE
			leaf_coins += 25
			experience += 60
			return _success("Quête terminée", "La forêt retrouve son calme. Récompense : 25 Leaf Coins et 60 XP.")
		QUEST_COMPLETE:
			return _success("Owl Sage", "Whispering Woods grandira avec tes prochaines aventures.")
	return _failure("Owl Sage ne répond pas.")


func collect_berry(berry_id: String) -> Dictionary:
	if berry_id not in BERRY_IDS:
		return _failure("Ce buisson n'existe pas.")
	if berry_id in collected_berries:
		return _failure("Ce buisson a déjà été récolté.")
	collected_berries.append(berry_id)
	glow_berries += 1
	if quest_stage == QUEST_COLLECT and collected_berries.size() >= 3:
		quest_stage = QUEST_HUNT
	return _success("Récolte", "Glow Berry obtenue (%d dans le sac)." % glow_berries)


func trade_at_post() -> Dictionary:
	if glow_berries < 1:
		return _failure("Il faut 1 Glow Berry pour échanger.")
	glow_berries -= 1
	leaf_coins += 5
	return _success("Échange", "1 Glow Berry échangée contre 5 Leaf Coins.")


func place_home_decoration(decoration_id: String = "Glow Lantern") -> Dictionary:
	if decoration_id in decorations:
		return _failure("Glow Lantern est déjà installée sur le Home Plot.")
	if leaf_coins < 10:
		return _failure("Il faut 10 Leaf Coins pour installer Glow Lantern.")
	leaf_coins -= 10
	decorations.append(decoration_id)
	return _success("Décoration", "Glow Lantern a été installée et sauvegardée.")


func rest_at_shrine() -> Dictionary:
	energy = 5
	return _success("Moon Shrine", "Votre énergie d'exploration est restaurée.")


func register_combat_result(encounter_id: String, outcome: String) -> Dictionary:
	if outcome != "victory":
		energy = max(0, energy - 1)
		return _success("Retour", "%s revient au village pour récupérer." % get_hero_display_name())
	var is_first_victory := encounter_id not in defeated_encounters
	if encounter_id not in defeated_encounters:
		defeated_encounters.append(encounter_id)
		leaf_coins += 8
		experience += 40
	else:
		leaf_coins += 2
		experience += 10
	if encounter_id == "moss_slime_woods" and quest_stage == QUEST_HUNT:
		quest_stage = QUEST_RETURN
	if is_first_victory:
		return _success("Victoire", "Moss Slime est apaisé. Récompense : 8 Leaf Coins et 40 XP. Il réapparaît pour l'entraînement.")
	return _success("Victoire", "Moss Slime réapparaît. Récompense d'entraînement : 2 Leaf Coins et 10 XP.")


func is_encounter_defeated(encounter_id: String) -> bool:
	return encounter_id in defeated_encounters


func to_dictionary() -> Dictionary:
	return {
		"hero_class_id": hero_class_id,
		"player_position": {"x": player_position.x, "y": player_position.y},
		"leaf_coins": leaf_coins,
		"experience": experience,
		"glow_berries": glow_berries,
		"energy": energy,
		"quest_stage": quest_stage,
		"collected_berries": collected_berries.duplicate(),
		"defeated_encounters": defeated_encounters.duplicate(),
		"decorations": decorations.duplicate(),
	}


func load_dictionary(data: Dictionary) -> void:
	var saved_hero_id := str(data.get("hero_class_id", ""))
	hero_class_id = saved_hero_id if HeroCatalogScript.is_valid(saved_hero_id) else ""
	var position_data: Dictionary = data.get("player_position", {})
	player_position = Vector2(
		float(position_data.get("x", START_POSITION.x)),
		float(position_data.get("y", START_POSITION.y))
	)
	leaf_coins = maxi(0, int(data.get("leaf_coins", 12)))
	experience = maxi(0, int(data.get("experience", 0)))
	glow_berries = maxi(0, int(data.get("glow_berries", 0)))
	energy = clampi(int(data.get("energy", 5)), 0, 5)
	quest_stage = str(data.get("quest_stage", QUEST_NOT_STARTED))
	collected_berries = _string_array(data.get("collected_berries", []))
	defeated_encounters = _string_array(data.get("defeated_encounters", []))
	decorations = _string_array(data.get("decorations", []))


func _string_array(source: Variant) -> Array[String]:
	var result: Array[String] = []
	if source is Array:
		for value in source:
			result.append(str(value))
	return result


func _success(title: String, message: String) -> Dictionary:
	return {"ok": true, "title": title, "message": message}


func _failure(message: String) -> Dictionary:
	return {"ok": false, "title": "Action impossible", "message": message}
