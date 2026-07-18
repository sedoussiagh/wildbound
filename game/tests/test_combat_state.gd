extends SceneTree

const CombatStateScript = preload("res://scripts/combat/combat_state.gd")

var failures := 0


func _init() -> void:
	_test_spec_damage_values()
	_test_illegal_move_is_atomic()
	_test_two_claw_strikes_win()
	_test_enemy_turn_is_deterministic()
	_test_soft_bump_uses_all_available_ap()

	if failures == 0:
		print("PASS: 5 deterministic combat tests")
	else:
		printerr("FAIL: %d combat test(s)" % failures)
	quit(failures)


func _test_spec_damage_values() -> void:
	_assert_equal(
		CombatStateScript.calculate_damage(20, 18, 4, 0.8),
		32,
		"Claw Strike follows the normative damage formula"
	)
	_assert_equal(
		CombatStateScript.calculate_damage(10, 12, 16, 0.5),
		13,
		"Soft Bump follows the normative damage formula"
	)


func _test_illegal_move_is_atomic() -> void:
	var state = CombatStateScript.new()
	var original_position: Vector2i = state.player_position
	var original_mp: int = state.player_mp
	var result: Dictionary = state.try_player_move(state.obstacles[0])
	_assert_equal(result.get("ok"), false, "Obstacle move is rejected")
	_assert_equal(state.player_position, original_position, "Rejected move keeps position")
	_assert_equal(state.player_mp, original_mp, "Rejected move keeps MP")


func _test_two_claw_strikes_win() -> void:
	var state = CombatStateScript.new()
	state.player_position = state.enemy_position + Vector2i.LEFT
	var first: Dictionary = state.player_claw_strike(state.enemy_position)
	var second: Dictionary = state.player_claw_strike(state.enemy_position)
	_assert_equal(first.get("damage"), 32, "First Claw Strike deals exact preview damage")
	_assert_equal(second.get("victory"), true, "Second Claw Strike ends the tutorial encounter")
	_assert_equal(state.enemy_health, 0, "Health never becomes negative")
	_assert_equal(state.outcome, "victory", "Victory outcome is deterministic")


func _test_enemy_turn_is_deterministic() -> void:
	var first = CombatStateScript.new()
	var second = CombatStateScript.new()
	var first_result: Dictionary = first.end_player_turn()
	var second_result: Dictionary = second.end_player_turn()
	_assert_equal(first.enemy_position, second.enemy_position, "Enemy path tie-break is deterministic")
	_assert_equal(first.player_health, second.player_health, "Enemy damage is deterministic")
	_assert_equal(first_result.events, second_result.events, "Same state and action produce the same events")


func _test_soft_bump_uses_all_available_ap() -> void:
	var state = CombatStateScript.new()
	state.enemy_position = state.player_position + Vector2i.RIGHT
	var result: Dictionary = state.end_player_turn()
	var attack_count := 0
	for event in result.events:
		if event.get("type") == "enemy_attack":
			attack_count += 1
	_assert_equal(attack_count, 1, "Moss Slime spends its available AP when adjacent")
	_assert_equal(state.player_health, 112, "One Soft Bump deals 13 damage")


func _assert_equal(actual, expected, label: String) -> void:
	if actual == expected:
		print("PASS: %s" % label)
		return
	failures += 1
	printerr("FAIL: %s — expected %s, got %s" % [label, str(expected), str(actual)])
