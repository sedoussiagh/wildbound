extends SceneTree

const WorldStateScript = preload("res://scripts/world/world_state.gd")

var failures := 0


func _init() -> void:
	_test_first_bloom_progression()
	_test_repeatable_encounter()
	_test_trade_and_decoration()
	_test_serialization_round_trip()
	if failures == 0:
		print("PASS: 4 deterministic open-world tests")
	else:
		printerr("FAIL: %d open-world assertion(s)" % failures)
	quit(failures)


func _test_first_bloom_progression() -> void:
	var state = WorldStateScript.new()
	state.interact_with_sage()
	_assert_equal(state.quest_stage, "collect", "Owl Sage starts First Bloom")
	for berry_id in state.BERRY_IDS:
		_assert_equal(state.collect_berry(berry_id).ok, true, "Each unique Glow Berry can be collected")
	_assert_equal(state.collect_berry("berry_north").ok, false, "A Glow Berry cannot be collected twice")
	_assert_equal(state.quest_stage, "hunt", "Three berries unlock the encounter objective")
	state.register_combat_result("moss_slime_woods", "victory")
	_assert_equal(state.quest_stage, "return", "Victory asks the player to return to Owl Sage")
	state.interact_with_sage()
	_assert_equal(state.quest_stage, "complete", "Owl Sage completes First Bloom")
	_assert_equal(state.experience, 100, "Quest and encounter award 100 total XP")


func _test_trade_and_decoration() -> void:
	var state = WorldStateScript.new()
	state.collect_berry("berry_north")
	var trade: Dictionary = state.trade_at_post()
	_assert_equal(trade.ok, true, "Trade Post accepts one Glow Berry")
	_assert_equal(state.leaf_coins, 17, "Trade awards five Leaf Coins")
	var decoration: Dictionary = state.place_home_decoration()
	_assert_equal(decoration.ok, true, "Home Plot accepts a decoration purchase")
	_assert_equal("Glow Lantern" in state.decorations, true, "Placed decoration is persisted in state")
	_assert_equal(state.place_home_decoration().ok, false, "The same decoration cannot be bought twice")


func _test_repeatable_encounter() -> void:
	var state = WorldStateScript.new()
	state.register_combat_result("moss_slime_woods", "victory")
	state.register_combat_result("moss_slime_woods", "victory")
	_assert_equal(state.experience, 50, "A respawned Moss Slime gives reduced training XP")
	_assert_equal(state.leaf_coins, 22, "A repeat victory gives reduced training coins")
	_assert_equal(state.is_encounter_defeated("moss_slime_woods"), true, "First-clear history remains persisted")


func _test_serialization_round_trip() -> void:
	var source = WorldStateScript.new()
	source.choose_hero("class.fox_mystic")
	source.player_position = Vector2(321, 456)
	source.collect_berry("berry_east")
	source.place_home_decoration()
	var restored = WorldStateScript.new()
	restored.load_dictionary(source.to_dictionary())
	_assert_equal(restored.player_position, Vector2(321, 456), "World position survives serialization")
	_assert_equal(restored.hero_class_id, "class.fox_mystic", "Selected hero survives serialization")
	_assert_equal(restored.collected_berries, source.collected_berries, "Collected resources survive serialization")
	_assert_equal(restored.decorations, source.decorations, "Decorations survive serialization")


func _assert_equal(actual, expected, label: String) -> void:
	if actual == expected:
		print("PASS: %s" % label)
		return
	failures += 1
	printerr("FAIL: %s — expected %s, got %s" % [label, str(expected), str(actual)])
