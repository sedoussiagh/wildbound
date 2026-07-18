extends SceneTree

var failures := 0


func _init() -> void:
	_run_test()


func _run_test() -> void:
	var scene: PackedScene = load("res://scenes/poc/battle_poc.tscn")
	var battle = scene.instantiate()
	battle.randomize_encounter = false
	battle.configure_hero("class.fox_mystic")
	root.add_child(battle)
	await process_frame
	await process_frame

	_assert_equal(battle.combat_state.player_basic_skill_name, "Spark Bolt", "Ranged combat HUD uses Spark Bolt")
	_assert_equal(battle.attack_button.icon.resource_path, "res://assets/ui/icons/spark_bolt.png", "Ranged action uses its dedicated icon")
	battle.combat_state.player_position = battle.combat_state.enemy_position + Vector2i(-4, 0)
	battle.board.sync_visual_positions()
	battle._on_attack_pressed()
	await battle._on_cell_pressed(battle.combat_state.enemy_position)
	_assert_equal(battle.combat_state.enemy_health, 21, "Animated Spark Bolt deals ranged damage")
	battle._on_attack_pressed()
	await battle._on_cell_pressed(battle.combat_state.enemy_position)
	_assert_equal(battle.combat_state.outcome, "victory", "Two animated Spark Bolts win the encounter")
	_assert_equal(battle.board.spark_strength, 0.0, "Projectile effect cleans up after impact")

	if failures == 0:
		print("PASS: Fox Mystic ranged visual smoke test")
	else:
		printerr("FAIL: %d Fox Mystic visual assertion(s)" % failures)
	quit(failures)


func _assert_equal(actual, expected, label: String) -> void:
	if actual == expected:
		print("PASS: %s" % label)
		return
	failures += 1
	printerr("FAIL: %s — expected %s, got %s" % [label, str(expected), str(actual)])
