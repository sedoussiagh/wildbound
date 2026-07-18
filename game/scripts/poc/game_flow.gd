class_name GameFlow
extends Control

const WorldStateScript = preload("res://scripts/world/world_state.gd")
const CHARACTER_SELECT_SCENE: PackedScene = preload("res://scenes/poc/character_select.tscn")
const WORLD_SCENE: PackedScene = preload("res://scenes/world/world_poc.tscn")
const BATTLE_SCENE: PackedScene = preload("res://scenes/poc/battle_poc.tscn")
const SAVE_PATH := "user://wildbound_open_world_poc.json"

var world_state = WorldStateScript.new()
var current_scene: Control
var persistence_enabled := true
@onready var scene_host: Control = %SceneHost
@onready var _transition_overlay: ColorRect = %TransitionOverlay


func _ready() -> void:
	if persistence_enabled:
		_load_game()
	if world_state.hero_class_id == "":
		_show_character_select()
	else:
		_show_world()


func _show_world(resume_message: String = "") -> void:
	var world = WORLD_SCENE.instantiate()
	world.configure(world_state, resume_message)
	world.combat_requested.connect(_on_combat_requested)
	world.class_change_requested.connect(_on_class_change_requested)
	world.state_changed.connect(_save_game)
	_replace_scene(world)


func _show_character_select(allow_cancel: bool = false) -> void:
	var character_select = CHARACTER_SELECT_SCENE.instantiate()
	character_select.configure(world_state.hero_class_id, allow_cancel)
	character_select.character_confirmed.connect(_on_character_confirmed)
	if allow_cancel:
		character_select.cancel_requested.connect(_on_character_selection_cancelled)
	_replace_scene(character_select)


func _on_character_confirmed(hero_id: String) -> void:
	call_deferred("_complete_character_selection", hero_id)


func _complete_character_selection(hero_id: String) -> void:
	var result: Dictionary = world_state.choose_hero(hero_id)
	if not result.get("ok", false):
		return
	_save_game()
	_show_world(str(result.get("message", "Bienvenue dans WILDBOUND.")))


func _on_class_change_requested() -> void:
	call_deferred("_show_character_select", true)


func _on_character_selection_cancelled() -> void:
	call_deferred("_show_world", "Changement de classe annulé.")


func _on_combat_requested(encounter_id: String) -> void:
	_save_game()
	call_deferred("_show_combat", encounter_id)


func _show_combat(encounter_id: String) -> void:
	var battle = BATTLE_SCENE.instantiate()
	battle.configure_hero(world_state.hero_class_id)
	battle.configure_encounter(encounter_id)
	battle.enable_world_return(encounter_id)
	battle.battle_finished.connect(_on_battle_finished)
	_replace_scene(battle)


func _on_battle_finished(outcome: String, encounter_id: String) -> void:
	call_deferred("_complete_battle", outcome, encounter_id)


func _complete_battle(outcome: String, encounter_id: String) -> void:
	var result: Dictionary = world_state.register_combat_result(encounter_id, outcome)
	_save_game()
	_show_world(str(result.get("message", "Retour à Whispering Woods.")))


func _replace_scene(next_scene: Control) -> void:
	if current_scene != null and is_instance_valid(current_scene):
		scene_host.remove_child(current_scene)
		current_scene.free()
	current_scene = next_scene
	current_scene.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scene_host.add_child(current_scene)
	_transition_overlay.modulate.a = 0.52
	var tween := create_tween()
	tween.tween_property(_transition_overlay, "modulate:a", 0.0, 0.28)


func _save_game() -> void:
	if not persistence_enabled:
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(world_state.to_dictionary()))


func _load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		world_state.load_dictionary(parsed)
