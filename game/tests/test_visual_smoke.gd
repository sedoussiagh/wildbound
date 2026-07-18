extends SceneTree

var failures := 0


func _init() -> void:
	_run_visual_smoke_test()


func _run_visual_smoke_test() -> void:
	var scene_resource: PackedScene = load("res://scenes/poc/battle_poc.tscn")
	var battle = scene_resource.instantiate()
	root.add_child(battle)
	await process_frame
	await process_frame

	await battle._on_cell_pressed(Vector2i(3, 4))
	_assert_equal(battle.combat_state.player_position, Vector2i(3, 4), "Animated player movement reaches D5")

	await battle._on_end_turn_pressed()
	_assert_equal(battle.combat_state.enemy_position, Vector2i(4, 4), "Animated enemy movement reaches E5")
	_assert_equal(battle.combat_state.player_health, 86, "Three animated Soft Bumps resolve correctly")

	battle._on_attack_pressed()
	await battle._on_cell_pressed(battle.combat_state.enemy_position)
	battle._on_attack_pressed()
	await battle._on_cell_pressed(battle.combat_state.enemy_position)
	_assert_equal(battle.combat_state.outcome, "victory", "Animated encounter reaches victory")
	_assert_equal(battle.board.enemy_alpha, 0.0, "Victory animation fades Moss Slime")

	if failures == 0:
		print("PASS: complete animated visual smoke test")
	else:
		printerr("FAIL: %d visual smoke assertion(s)" % failures)
	quit(failures)


func _assert_equal(actual, expected, label: String) -> void:
	if actual == expected:
		print("PASS: %s" % label)
		return
	failures += 1
	printerr("FAIL: %s — expected %s, got %s" % [label, str(expected), str(actual)])
