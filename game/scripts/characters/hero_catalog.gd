class_name HeroCatalog
extends RefCounted

const WOLF_GUARDIAN := "class.wolf_guardian"
const FOX_MYSTIC := "class.fox_mystic"
const AVAILABLE_HERO_IDS := [WOLF_GUARDIAN, FOX_MYSTIC]
const HERO_DEFINITIONS := {
	WOLF_GUARDIAN: preload("res://resources/heroes/wolf_guardian.tres"),
	FOX_MYSTIC: preload("res://resources/heroes/fox_mystic.tres"),
}


static func is_valid(hero_id: String) -> bool:
	return hero_id in AVAILABLE_HERO_IDS


static func get_hero(hero_id: String) -> Dictionary:
	return get_definition(hero_id).to_dictionary()


static func get_definition(hero_id: String) -> HeroDefinition:
	var valid_id := hero_id if is_valid(hero_id) else WOLF_GUARDIAN
	return HERO_DEFINITIONS[valid_id] as HeroDefinition


static func get_display_name(hero_id: String) -> String:
	return str(get_hero(hero_id).display_name)


static func get_basic_skill_name(hero_id: String) -> String:
	return str(get_hero(hero_id).basic_skill)
