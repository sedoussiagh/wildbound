extends SceneTree

const CombatStateScript = preload("res://scripts/combat/combat_state.gd")

var failures := 0


func _init() -> void:
	_test_wolf_guardian_defaults()
	_test_fox_mystic_range_and_line_of_sight()
	if failures == 0:
		print("PASS: 2 deterministic character-class tests")
	else:
		printerr("FAIL: %d character-class assertion(s)" % failures)
	quit(failures)


func _test_wolf_guardian_defaults() -> void:
	var state = CombatStateScript.new()
	_assert_equal(state.player_display_name, "Wolf Guardian", "Wolf Guardian remains the default class")
	_assert_equal(state.player_max_health, 125, "Wolf Guardian keeps 125 HP")
	_assert_equal(state.preview_basic_attack_damage(), 32, "Claw Strike keeps its normative damage")
	_assert_equal(state.player_basic_skill_range, 1, "Claw Strike remains melee")


func _test_fox_mystic_range_and_line_of_sight() -> void:
	var state = CombatStateScript.new()
	state.configure_hero("class.fox_mystic")
	_assert_equal(state.player_display_name, "Fox Mystic", "Fox Mystic can be configured")
	_assert_equal(state.player_health, 100, "Fox Mystic starts with 100 HP")
	_assert_equal(state.player_power, 24, "Fox Mystic starts with 24 Power")
	_assert_equal(state.player_basic_skill_name, "Spark Bolt", "Fox Mystic uses Spark Bolt")
	_assert_equal(state.preview_basic_attack_damage(), 34, "Spark Bolt follows its normative damage formula")
	_assert_equal(state.can_use_basic_attack(), false, "A pillar blocks the initial line of sight")
	state.player_position = Vector2i(2, 4)
	_assert_equal(state.manhattan_distance(state.player_position, state.enemy_position), 4, "Fox Mystic can attack from four cells away")
	_assert_equal(state.has_line_of_sight(state.player_position, state.enemy_position), true, "Moving around the pillar opens line of sight")
	var result: Dictionary = state.player_basic_attack(state.enemy_position)
	_assert_equal(result.get("damage"), 34, "Spark Bolt damages Moss Slime at range")
	_assert_equal(state.enemy_health, 21, "Ranged damage updates enemy health")


func _assert_equal(actual, expected, label: String) -> void:
	if actual == expected:
		print("PASS: %s" % label)
		return
	failures += 1
	printerr("FAIL: %s — expected %s, got %s" % [label, str(expected), str(actual)])
