extends SceneTree

var failures := 0


func _init() -> void:
	_run_test()


func _run_test() -> void:
	var scene: PackedScene = load("res://scenes/poc/battle_poc.tscn")
	var battle = scene.instantiate()
	battle.randomize_encounter = false
	root.add_child(battle)
	await process_frame
	await process_frame

	_assert_equal(battle.attack_button.text, "", "Spell dock displays the skill as an icon only")
	_assert_equal("Claw Strike" in battle.attack_button.tooltip_text, true, "Hover tooltip contains the skill name")
	_assert_equal("1 PA" in battle.attack_button.tooltip_text, true, "Hover tooltip contains the skill cost")
	_assert_equal(battle.player_hp_bar.value, 125.0, "Player HP bar mirrors combat state")
	_assert_equal(battle.player_ap_value.text, "PA  3", "PA is displayed as a dedicated badge")
	_assert_equal(battle.player_mp_value.text, "PM  3", "PM is displayed as a dedicated badge")
	_assert_equal(battle.timer_bar.max_value, 30.0, "Turn timer uses a 30-second bar")
	_assert_equal(battle.skill_buttons.size(), 3, "The spell dock contains three spell buttons")
	_assert_equal(battle.combat_state.player_skills.size(), 3, "Wolf Guardian has three modular spells")

	battle._on_attack_pressed()
	_assert_equal(battle.board.range_cells.size(), 4, "Selecting Claw Strike previews all four adjacent range cells")
	_assert_equal(battle.board.movement_cells.is_empty(), true, "Movement overlay is hidden while a spell is selected")
	battle._on_skill_hover_started()
	_assert_equal(battle.skill_tooltip.visible, true, "Hover displays the description panel above the spell")
	battle._on_skill_hover_ended()
	_assert_equal(battle.skill_tooltip.visible, false, "Leaving the icon hides the description panel")
	var arena_before: int = battle.combat_state.arena_index
	var group_before: int = battle.combat_state.encounter_group_size
	battle._on_change_hero_pressed()
	_assert_equal(battle.combat_state.hero_class_id, "class.fox_mystic", "Change button switches to the other character")
	_assert_equal(battle.combat_state.arena_index, arena_before, "Changing character preserves the arena layout")
	_assert_equal(battle.combat_state.encounter_group_size, group_before, "Changing character preserves the Slime group")
	_assert_equal(battle.combat_state.player_skills.size(), 3, "Fox Mystic also has three modular spells")

	battle._on_cancel_pressed()
	battle.turn_time_remaining = 0.01
	battle._process(0.02)
	await create_timer(1.5).timeout
	_assert_equal(battle.combat_state.turn_number, 2, "Expired timer automatically resolves the enemy turn")
	_assert_equal(battle.turn_time_remaining > 28.0, true, "A new player turn resets the timer")

	if failures == 0:
		print("PASS: minimal combat HUD, range preview, and automatic turn timer")
	else:
		printerr("FAIL: %d combat HUD assertion(s)" % failures)
	quit(failures)


func _assert_equal(actual, expected, label: String) -> void:
	if actual == expected:
		print("PASS: %s" % label)
		return
	failures += 1
	printerr("FAIL: %s — expected %s, got %s" % [label, str(expected), str(actual)])
