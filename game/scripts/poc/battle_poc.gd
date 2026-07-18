extends Control

signal battle_finished(outcome: String, encounter_id: String)

const CombatStateScript = preload("res://scripts/combat/combat_state.gd")
const HeroCatalogScript = preload("res://scripts/characters/hero_catalog.gd")
const TURN_DURATION := 30.0
const ENCOUNTER_GROUP_SIZES := {
	"moss_slime_woods": 1,
	"moss_slime_creek": 2,
	"moss_slime_ruins": 3,
}

@export var encounter_seed := 0
@export var randomize_encounter := true

var combat_state = CombatStateScript.new()
@onready var board: BattleBoard = %BattleBoard
@onready var turn_label: Label = %TurnLabel
@onready var arena_label: Label = %ArenaLabel
@onready var timer_bar: ProgressBar = %TurnTimerBar
@onready var timer_label: Label = %TurnTimerLabel
@onready var hero_name_label: Label = %HeroNameLabel
@onready var player_hp_bar: ProgressBar = %PlayerHPBar
@onready var player_hp_value: Label = %PlayerHPValue
@onready var player_ap_value: Label = %PlayerAPValue
@onready var player_mp_value: Label = %PlayerMPValue
@onready var enemy_name_label: Label = %EnemyNameLabel
@onready var enemy_hp_bar: ProgressBar = %EnemyHPBar
@onready var enemy_hp_value: Label = %EnemyHPValue
@onready var status_label: Label = %StatusLabel
@onready var log_label: RichTextLabel = %LogLabel
@onready var attack_button: Button = %AttackButton
@onready var skill_button_2: Button = %SkillButton2
@onready var skill_button_3: Button = %SkillButton3
@onready var end_turn_button: Button = %EndTurnButton
@onready var change_hero_button: Button = %ChangeHeroButton
@onready var restart_button: Button = %RestartButton
@onready var skill_tooltip: PanelContainer = %SkillTooltip
@onready var skill_tooltip_label: Label = %SkillTooltipLabel

var skill_buttons: Array[Button] = []
var mode := "move"
var selected_skill_id := ""
var selected_target := Vector2i(-1, -1)
var history: Array[String] = []
var is_animating := false
var world_return_enabled := false
var world_encounter_id := ""
var auto_return_delay := 0.75
var turn_time_remaining := TURN_DURATION
var _turn_timeout_pending := false
var requested_group_size := 0


func configure_hero(hero_id: String) -> void:
	combat_state.configure_hero(hero_id)


func enable_world_return(encounter_id: String) -> void:
	world_return_enabled = true
	world_encounter_id = encounter_id


func configure_encounter(encounter_id: String) -> void:
	requested_group_size = int(ENCOUNTER_GROUP_SIZES.get(encounter_id, 0))


func _ready() -> void:
	if randomize_encounter:
		combat_state.setup_random_encounter(encounter_seed, requested_group_size)
	skill_buttons = [attack_button, skill_button_2, skill_button_3]
	board.set_combat_state(combat_state)
	for index in range(skill_buttons.size()):
		var button := skill_buttons[index]
		button.text = ""
		button.pressed.connect(_on_skill_pressed.bind(index))
		button.mouse_entered.connect(_on_skill_hover_started.bind(index))
		button.mouse_exited.connect(_on_skill_hover_ended)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	change_hero_button.pressed.connect(_on_change_hero_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	board.cell_pressed.connect(_on_cell_pressed)
	board.sync_visual_positions()
	_refresh_skill_buttons()
	_append_log("Combat commencé dans %s : %d Slime(s)." % [combat_state.arena_name, combat_state.encounter_group_size])
	_reset_turn_timer()
	_refresh_interface()
	set_process(true)
	call_deferred("_focus_board")


func _process(delta: float) -> void:
	if not _timer_should_run():
		return
	turn_time_remaining = maxf(0.0, turn_time_remaining - delta)
	_update_timer_display()
	if turn_time_remaining <= 0.0 and not _turn_timeout_pending:
		_turn_timeout_pending = true
		status_label.text = "Temps écoulé · passage automatique au tour des Slimes…"
		_append_log("Les 30 secondes sont écoulées : le tour passe automatiquement.")
		call_deferred("_handle_turn_timeout")


func _timer_should_run() -> bool:
	return combat_state.is_player_turn and not combat_state.is_game_over and not is_animating and not _turn_timeout_pending


func _handle_turn_timeout() -> void:
	if not is_inside_tree() or combat_state.is_game_over or not combat_state.is_player_turn:
		_turn_timeout_pending = false
		return
	await _on_end_turn_pressed(true)


func _focus_board() -> void:
	board.grab_focus()
	board.set_focus_cell(combat_state.player_position)


func _on_cell_pressed(cell: Vector2i) -> void:
	if is_animating:
		return
	if combat_state.is_game_over:
		status_label.text = "Le combat est terminé."
		return
	if not combat_state.is_player_turn:
		status_label.text = "Les Moss Slimes jouent leur tour."
		return

	if mode == "attack":
		var enemy = combat_state.get_enemy_at(cell)
		if enemy == null:
			status_label.text = "Cette case ne contient aucune cible." if cell in board.range_cells else "Cette case est hors de portée."
			return
		if not combat_state.can_use_skill(selected_skill_id, cell):
			status_label.text = _skill_blocked_message(selected_skill_id, cell)
			return
		selected_target = cell
		await _execute_selected_skill()
		return

	var result := combat_state.try_player_move(cell)
	if result.get("ok", false):
		is_animating = true
		status_label.text = "%s se déplace…" % combat_state.player_display_name
		_refresh_interface(false)
		await board.animate_unit_path("player", result.path)
		_append_log("%s se déplace de %d case(s)." % [combat_state.player_display_name, result.cost])
		status_label.text = "Déplacement validé · %d PM restant(s)." % combat_state.player_mp
		is_animating = false
	else:
		status_label.text = result.get("reason", "Déplacement impossible.")
	_refresh_interface(false)


func _on_move_pressed() -> void:
	_on_cancel_pressed()


func _on_attack_pressed() -> void:
	_on_skill_pressed(0)


func _on_skill_pressed(index: int) -> void:
	if is_animating or index < 0 or index >= combat_state.player_skills.size():
		return
	var skill: SkillDefinition = combat_state.player_skills[index]
	if skill_buttons[index].disabled:
		return
	if mode == "attack" and selected_skill_id == skill.skill_id:
		_on_cancel_pressed()
		return
	mode = "attack"
	selected_skill_id = skill.skill_id
	selected_target = Vector2i(-1, -1)
	status_label.text = "%s sélectionné · touchez un Slime dans la zone orange." % skill.display_name
	_refresh_interface(false)


func _execute_claw_strike() -> void:
	await _execute_basic_attack()


func _execute_basic_attack() -> void:
	if combat_state.player_skills.is_empty():
		return
	selected_skill_id = combat_state.player_skills[0].skill_id
	await _execute_selected_skill()


func _execute_selected_skill() -> void:
	var skill := combat_state.get_skill(selected_skill_id)
	var target_enemy = combat_state.get_enemy_at(selected_target)
	if skill == null or target_enemy == null:
		status_label.text = "Sélectionnez un sort puis un Slime."
		return
	var result := combat_state.player_use_skill(selected_skill_id, selected_target)
	if not result.get("ok", false):
		status_label.text = result.get("reason", "Attaque impossible.")
		return

	is_animating = true
	mode = "move"
	selected_skill_id = ""
	selected_target = Vector2i(-1, -1)
	status_label.text = "%s !" % result.skill
	_refresh_interface(false)
	await board.animate_player_skill(skill, result.target_enemy_id, result.affected)
	for affected_enemy in result.affected:
		_append_log("%s inflige %d dégâts à %s." % [result.skill, affected_enemy.damage, _enemy_name(affected_enemy.enemy_id)])
		if affected_enemy.get("defeated", false):
			await board.animate_enemy_defeat(affected_enemy.enemy_id)

	var should_auto_return: bool = result.get("victory", false) and world_return_enabled
	if result.get("victory", false):
		await board.animate_victory()
		_append_log("Victoire : le groupe de Slimes est vaincu.")
		status_label.text = "Victoire ! Retour à Whispering Woods…" if should_auto_return else "Victoire !"
	else:
		var alive_count := combat_state.get_alive_enemies().size()
		status_label.text = "Attaque validée · %d Slime(s) encore debout." % alive_count
	is_animating = false
	_refresh_interface(false)
	if should_auto_return:
		await get_tree().create_timer(auto_return_delay).timeout
		if is_inside_tree() and combat_state.outcome == "victory":
			battle_finished.emit(combat_state.outcome, world_encounter_id)


func _on_cancel_pressed() -> void:
	if is_animating:
		return
	mode = "move"
	selected_skill_id = ""
	selected_target = Vector2i(-1, -1)
	status_label.text = "Déplacement libre · touchez une case cyan."
	_refresh_interface(false)


func _on_end_turn_pressed(auto_triggered: bool = false) -> void:
	if is_animating:
		return
	_turn_timeout_pending = true
	var result := combat_state.end_player_turn()
	if not result.get("ok", false):
		_turn_timeout_pending = false
		status_label.text = result.get("reason", "Impossible de terminer le tour.")
		return

	is_animating = true
	mode = "move"
	selected_skill_id = ""
	selected_target = Vector2i(-1, -1)
	status_label.text = "Tour automatique des Slimes…" if auto_triggered else "Tour des Slimes…"
	_refresh_interface(false)
	for event in result.events:
		match event.get("type", ""):
			"enemy_move":
				await board.animate_unit_path("enemy", event.path, event.enemy_id)
				_append_log("%s se déplace de %d case(s)." % [_enemy_name(event.enemy_id), event.cost])
			"enemy_attack":
				await board.animate_soft_bump(event.damage, event.enemy_id)
				_append_log("Soft Bump inflige %d dégâts à %s." % [event.damage, combat_state.player_display_name])
			"defeat":
				await board.animate_defeat()
				_append_log("Défaite : %s n'a plus de HP." % combat_state.player_display_name)

	status_label.text = "Défaite · recommencez pour essayer une autre approche." if combat_state.outcome == "defeat" else "Tour %d · HP, PA et PM actualisés." % combat_state.turn_number
	is_animating = false
	if not combat_state.is_game_over:
		_reset_turn_timer()
	else:
		_turn_timeout_pending = false
	_refresh_interface(false)


func _on_change_hero_pressed() -> void:
	if is_animating:
		return
	var next_hero := HeroCatalogScript.FOX_MYSTIC if combat_state.hero_class_id == HeroCatalogScript.WOLF_GUARDIAN else HeroCatalogScript.WOLF_GUARDIAN
	combat_state.configure_hero(next_hero)
	mode = "move"
	selected_skill_id = ""
	selected_target = Vector2i(-1, -1)
	history.clear()
	board.set_combat_state(combat_state)
	board.sync_visual_positions()
	_refresh_skill_buttons()
	_append_log("Personnage changé : %s. Le combat redémarre sur la même arène." % combat_state.player_display_name)
	status_label.text = "Nouveau personnage prêt · choisissez un sort ou déplacez-vous."
	_reset_turn_timer()
	_refresh_interface(false)


func _on_restart_pressed() -> void:
	if is_animating:
		return
	if world_return_enabled and combat_state.is_game_over:
		battle_finished.emit(combat_state.outcome, world_encounter_id)
		return
	combat_state.reset()
	mode = "move"
	selected_skill_id = ""
	selected_target = Vector2i(-1, -1)
	history.clear()
	board.set_combat_state(combat_state)
	board.sync_visual_positions()
	_append_log("Nouveau combat dans %s contre %d Slime(s)." % [combat_state.arena_name, combat_state.encounter_group_size])
	status_label.text = "Déplacement libre · touchez une case cyan."
	_reset_turn_timer()
	_refresh_interface(false)


func _refresh_skill_buttons() -> void:
	for index in range(skill_buttons.size()):
		var button := skill_buttons[index]
		if index >= combat_state.player_skills.size():
			button.visible = false
			continue
		var skill: SkillDefinition = combat_state.player_skills[index]
		button.visible = true
		button.icon = skill.icon
		button.tooltip_text = _skill_description(skill)


func _refresh_interface(reset_status: bool = true) -> void:
	var alive_count := combat_state.get_alive_enemies().size()
	turn_label.text = "TOUR %d · %s" % [combat_state.turn_number, "VOUS" if combat_state.is_player_turn else "SLIMES"]
	arena_label.text = "%s · groupe de %d" % [combat_state.arena_name, combat_state.encounter_group_size]
	hero_name_label.text = combat_state.player_display_name
	player_hp_bar.max_value = combat_state.player_max_health
	player_hp_bar.value = combat_state.player_health
	player_hp_value.text = "%d / %d" % [combat_state.player_health, combat_state.player_max_health]
	player_ap_value.text = "PA  %d" % combat_state.player_ap
	player_mp_value.text = "PM  %d" % combat_state.player_mp
	enemy_name_label.text = "Moss Slimes ×%d" % alive_count
	enemy_hp_bar.max_value = combat_state.get_total_enemy_max_health()
	enemy_hp_bar.value = combat_state.get_total_enemy_health()
	enemy_hp_value.text = "%d / %d" % [combat_state.get_total_enemy_health(), combat_state.get_total_enemy_max_health()]

	var player_can_act: bool = combat_state.is_player_turn and not combat_state.is_game_over and not is_animating
	for index in range(skill_buttons.size()):
		if index >= combat_state.player_skills.size():
			continue
		var skill: SkillDefinition = combat_state.player_skills[index]
		skill_buttons[index].disabled = not player_can_act or combat_state.player_ap < skill.ap_cost
		skill_buttons[index].button_pressed = player_can_act and mode == "attack" and selected_skill_id == skill.skill_id
	end_turn_button.disabled = not player_can_act
	change_hero_button.disabled = is_animating
	restart_button.disabled = is_animating
	if world_return_enabled:
		restart_button.visible = combat_state.is_game_over and combat_state.outcome != "victory"
		restart_button.tooltip_text = "Retourner à Whispering Woods"
	else:
		restart_button.visible = combat_state.is_game_over
		restart_button.tooltip_text = "Recommencer le combat"

	var movement_preview: Array[Vector2i] = []
	if player_can_act and mode == "move":
		movement_preview = combat_state.get_reachable_player_cells()
	board.movement_cells = movement_preview
	var range_preview: Array[Vector2i] = []
	if player_can_act and mode == "attack":
		range_preview = combat_state.get_skill_range_cells(selected_skill_id)
	board.range_cells = range_preview
	var legal_attack_cells: Array[Vector2i] = []
	if player_can_act and mode == "attack":
		for enemy in combat_state.get_alive_enemies():
			if combat_state.can_use_skill(selected_skill_id, enemy.position):
				legal_attack_cells.append(enemy.position)
	board.attack_cells = legal_attack_cells
	board.selected_cell = selected_target
	board.is_animating = is_animating
	board.set_combat_state(combat_state)

	if reset_status:
		if combat_state.is_game_over:
			status_label.text = "Victoire !" if combat_state.outcome == "victory" else "Défaite."
		elif mode == "move":
			status_label.text = "Déplacement libre · touchez une case cyan."
	_update_timer_display()
	_update_log_text()


func _skill_description(skill: SkillDefinition) -> String:
	var target_text := "zone %d" % skill.area_radius if skill.target_mode == "area" else ("jusqu'à %d cibles" % skill.max_targets if skill.target_mode == "chain" else "cible unique")
	var sight_text := " · ligne de vue" if skill.requires_line_of_sight else ""
	return "%s\n%s\n%d dégâts · %d PA · portée %d%s · %s\nTouchez l'icône, puis un Slime." % [skill.display_name, skill.description, combat_state.preview_skill_damage(skill.skill_id), skill.ap_cost, skill.cast_range, sight_text, target_text]


func _on_skill_hover_started(index: int = 0) -> void:
	if index >= combat_state.player_skills.size():
		return
	skill_tooltip_label.text = _skill_description(combat_state.player_skills[index])
	skill_tooltip.visible = true


func _on_skill_hover_ended() -> void:
	skill_tooltip.visible = false


func _reset_turn_timer() -> void:
	turn_time_remaining = TURN_DURATION
	_turn_timeout_pending = false
	_update_timer_display()


func _update_timer_display() -> void:
	if timer_bar == null:
		return
	timer_bar.max_value = TURN_DURATION
	timer_bar.value = turn_time_remaining
	timer_label.text = "%02ds" % ceili(turn_time_remaining)
	if turn_time_remaining <= 5.0:
		timer_bar.modulate = Color("#ff6f61")
	elif turn_time_remaining <= 10.0:
		timer_bar.modulate = Color("#ffc45f")
	else:
		timer_bar.modulate = Color.WHITE


func _append_log(message: String) -> void:
	history.append(message)
	if history.size() > 4:
		history.pop_front()
	_update_log_text()


func _update_log_text() -> void:
	if log_label != null:
		log_label.text = "\n".join(history)


func _enemy_name(enemy_id: String) -> String:
	var enemy = combat_state.get_enemy_by_id(enemy_id)
	return enemy.display_name if enemy != null else "Moss Slime"


func _skill_blocked_message(skill_id: String, target: Vector2i) -> String:
	var skill := combat_state.get_skill(skill_id)
	if skill == null:
		return "Choisissez un sort."
	if combat_state.player_ap < skill.ap_cost:
		return "Pas assez de PA pour %s." % skill.display_name
	if combat_state.manhattan_distance(combat_state.player_position, target) > skill.cast_range:
		return "Cible hors de portée (%d cases)." % skill.cast_range
	if skill.requires_line_of_sight and not combat_state.has_line_of_sight(combat_state.player_position, target):
		return "Un obstacle bloque la ligne de vue."
	return "%s n'est pas disponible maintenant." % skill.display_name


func _basic_attack_blocked_message() -> String:
	return _skill_blocked_message(combat_state.player_skills[0].skill_id, combat_state.enemy_position)


func _unhandled_key_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.pressed or event.echo:
		return
	if is_animating and event.keycode != KEY_R:
		return
	var handled := true
	match event.keycode:
		KEY_UP:
			board.set_focus_cell(board.focus_cell + Vector2i.UP)
		KEY_DOWN:
			board.set_focus_cell(board.focus_cell + Vector2i.DOWN)
		KEY_LEFT:
			board.set_focus_cell(board.focus_cell + Vector2i.LEFT)
		KEY_RIGHT:
			board.set_focus_cell(board.focus_cell + Vector2i.RIGHT)
		KEY_ENTER, KEY_KP_ENTER:
			_on_cell_pressed(board.focus_cell)
		KEY_1, KEY_A:
			_on_skill_pressed(0)
		KEY_2:
			_on_skill_pressed(1)
		KEY_3:
			_on_skill_pressed(2)
		KEY_C:
			_on_change_hero_pressed()
		KEY_E:
			_on_end_turn_pressed()
		KEY_R:
			_on_restart_pressed()
		KEY_ESCAPE:
			_on_cancel_pressed()
		_:
			handled = false
	if handled:
		board.grab_focus()
		get_viewport().set_input_as_handled()
