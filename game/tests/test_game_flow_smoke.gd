extends SceneTree

var failures := 0


func _init() -> void:
	_run_flow_test()


func _run_flow_test() -> void:
	var flow_scene: PackedScene = load("res://scenes/poc/game_flow.tscn")
	var flow = flow_scene.instantiate()
	flow.persistence_enabled = false
	root.add_child(flow)
	await process_frame
	await process_frame
	_assert_equal(flow.current_scene.name, "CharacterSelect", "First launch starts with character selection")
	var character_select = flow.current_scene
	character_select.select_hero("class.fox_mystic")
	character_select.select_hero("class.wolf_guardian")
	character_select.select_hero("class.fox_mystic")
	_assert_equal(character_select.selected_hero_id, "class.fox_mystic", "Choice remains reversible before confirmation")
	character_select._on_confirm_pressed()
	await process_frame
	await process_frame
	_assert_equal(flow.current_scene.name, "WorldPoc", "Confirmed character enters the open world")
	_assert_equal(flow.world_state.hero_class_id, "class.fox_mystic", "Selected class persists in the world state")
	_assert_equal(flow.current_scene.world_canvas != null, true, "Open world canvas is ready")
	var world = flow.current_scene
	world._handle_world_tap(Vector2(600, 600))
	world._process(1.0)
	_assert_equal(flow.world_state.player_position.x > 500.0, true, "Tap-to-walk moves the selected hero across the map")
	flow.world_state.player_position = Vector2(165, 310)
	world._update_nearest_interaction()
	_assert_equal(world._nearest_interaction, "owl_sage", "Nearby Owl Sage becomes interactable")
	world._interact("owl_sage")
	_assert_equal(flow.world_state.quest_stage, "collect", "World interaction starts First Bloom")
	flow.world_state.player_position = Vector2(690, 390)
	world._update_nearest_interaction()
	world._handle_world_tap(Vector2(690, 300))
	await process_frame
	await process_frame
	await process_frame
	_assert_equal(flow.current_scene.name, "BattlePoc", "One monster click opens the combat scene")
	_assert_equal(flow.current_scene.world_return_enabled, true, "Combat knows it must return to the world")
	_assert_equal(flow.current_scene.combat_state.hero_class_id, "class.fox_mystic", "Combat uses the selected ranged hero")

	flow._complete_battle("victory", "moss_slime_woods")
	await process_frame
	await process_frame
	_assert_equal(flow.current_scene.name, "WorldPoc", "Victory returns to the open world")
	_assert_equal("moss_slime_woods" in flow.current_scene._active_interactions(), true, "Moss Slime respawns after victory")
	_assert_equal(flow.world_state.experience, 40, "Combat reward persists after the transition")

	world = flow.current_scene
	world._on_change_class_pressed()
	await process_frame
	await process_frame
	_assert_equal(flow.current_scene.name, "CharacterSelect", "Class can be changed from the open world")
	character_select = flow.current_scene
	_assert_equal(character_select.selected_hero_id, "class.fox_mystic", "Current class is preselected")
	character_select.select_hero("class.wolf_guardian")
	character_select._on_confirm_pressed()
	await process_frame
	await process_frame
	_assert_equal(flow.current_scene.name, "WorldPoc", "Confirming the new class returns to exploration")
	_assert_equal(flow.world_state.hero_class_id, "class.wolf_guardian", "Class changes without resetting progress")
	_assert_equal(flow.world_state.experience, 40, "Class change preserves experience")

	if failures == 0:
		print("PASS: complete exploration-to-combat flow test")
	else:
		printerr("FAIL: %d game-flow assertion(s)" % failures)
	quit(failures)


func _assert_equal(actual, expected, label: String) -> void:
	if actual == expected:
		print("PASS: %s" % label)
		return
	failures += 1
	printerr("FAIL: %s — expected %s, got %s" % [label, str(expected), str(actual)])
