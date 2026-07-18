extends SceneTree

var failures := 0
var emitted_outcome := ""
var emitted_encounter := ""


func _init() -> void:
	_run_test()


func _run_test() -> void:
	var scene: PackedScene = load("res://scenes/poc/battle_poc.tscn")
	var battle = scene.instantiate()
	battle.randomize_encounter = false
	battle.enable_world_return("moss_slime_woods")
	battle.auto_return_delay = 0.01
	battle.battle_finished.connect(_on_battle_finished)
	root.add_child(battle)
	await process_frame
	await process_frame

	battle.combat_state.player_position = battle.combat_state.enemy_position + Vector2i.LEFT
	battle.combat_state.enemy_health = battle.combat_state.preview_claw_strike_damage()
	battle.board.sync_visual_positions()
	battle.selected_target = battle.combat_state.enemy_position
	await battle._execute_claw_strike()
	await process_frame

	_assert_equal(battle.combat_state.outcome, "victory", "The final hit defeats Moss Slime")
	_assert_equal(emitted_outcome, "victory", "Victory automatically exits the combat")
	_assert_equal(emitted_encounter, "moss_slime_woods", "Automatic exit preserves the encounter id")
	_assert_equal(battle.restart_button.visible, false, "No manual return button is required after victory")

	if failures == 0:
		print("PASS: automatic combat exit after enemy defeat")
	else:
		printerr("FAIL: %d automatic-exit assertion(s)" % failures)
	quit(failures)


func _on_battle_finished(outcome: String, encounter_id: String) -> void:
	emitted_outcome = outcome
	emitted_encounter = encounter_id


func _assert_equal(actual, expected, label: String) -> void:
	if actual == expected:
		print("PASS: %s" % label)
		return
	failures += 1
	printerr("FAIL: %s — expected %s, got %s" % [label, str(expected), str(actual)])
