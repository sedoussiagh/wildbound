extends SceneTree

const CombatStateScript = preload("res://scripts/combat/combat_state.gd")

var failures := 0


func _init() -> void:
	_test_seeded_arena_is_deterministic()
	_test_encounters_vary()
	_test_three_slime_group()
	_test_area_skill_hits_a_group()
	if failures == 0:
		print("PASS: random 9x9 arenas, Slime groups, and area skills")
	else:
		printerr("FAIL: %d random-encounter assertion(s)" % failures)
	quit(failures)


func _test_seeded_arena_is_deterministic() -> void:
	var first = CombatStateScript.new()
	var second = CombatStateScript.new()
	first.setup_random_encounter(424242)
	second.setup_random_encounter(424242)
	_assert_equal(first.GRID_SIZE, 9, "Combat arena uses a larger 9x9 grid")
	_assert_equal(first.arena_id, second.arena_id, "Same seed selects the same arena")
	_assert_equal(first.encounter_group_size, second.encounter_group_size, "Same seed selects the same group size")
	_assert_equal(first.obstacles, second.obstacles, "Same seed selects the same obstacles")


func _test_encounters_vary() -> void:
	var arenas: Dictionary = {}
	var group_sizes: Dictionary = {}
	for seed_value in range(1, 25):
		var state = CombatStateScript.new()
		state.setup_random_encounter(seed_value)
		arenas[state.arena_id] = true
		group_sizes[state.encounter_group_size] = true
	_assert_equal(arenas.size() > 1, true, "Different seeds produce different arena layouts")
	_assert_equal(group_sizes.size() > 1, true, "Different seeds produce different Slime group sizes")


func _test_three_slime_group() -> void:
	var state = CombatStateScript.new()
	state.setup_encounter(1, 3, 99)
	var positions: Dictionary = {}
	for enemy in state.enemies:
		positions[enemy.position] = true
	_assert_equal(state.enemies.size(), 3, "An encounter can spawn three Moss Slimes")
	_assert_equal(positions.size(), 3, "Every Slime starts on a distinct cell")


func _test_area_skill_hits_a_group() -> void:
	var state = CombatStateScript.new()
	state.configure_hero("class.fox_mystic")
	state.setup_encounter(0, 3, 7)
	state.player_position = Vector2i(1, 4)
	state.enemies[0].position = Vector2i(5, 4)
	state.enemies[1].position = Vector2i(5, 5)
	state.enemies[2].position = Vector2i(6, 4)
	_assert_equal(state.player_skills.size(), 3, "Fox Mystic exposes exactly three spells")
	var result: Dictionary = state.player_use_skill("skill.ember_arc", Vector2i(5, 4))
	_assert_equal(result.get("ok"), true, "Ember Arc can be cast on the group")
	_assert_equal(result.get("affected", []).size(), 3, "Ember Arc damages all three compact Slimes")


func _assert_equal(actual, expected, label: String) -> void:
	if actual == expected:
		print("PASS: %s" % label)
		return
	failures += 1
	printerr("FAIL: %s — expected %s, got %s" % [label, str(expected), str(actual)])
