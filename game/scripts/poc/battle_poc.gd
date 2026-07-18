extends Control

signal battle_finished(outcome: String, encounter_id: String)

const CombatStateScript = preload("res://scripts/combat/combat_state.gd")
const HeroCatalogScript = preload("res://scripts/characters/hero_catalog.gd")

var combat_state = CombatStateScript.new()
@onready var board: BattleBoard = %BattleBoard
@onready var turn_label: Label = %TurnLabel
@onready var stats_label: Label = %StatsLabel
@onready var status_label: Label = %StatusLabel
@onready var instruction_label: Label = %InstructionLabel
@onready var log_label: RichTextLabel = %LogLabel
@onready var move_button: Button = %MoveButton
@onready var attack_button: Button = %AttackButton
@onready var cancel_button: Button = %CancelButton
@onready var end_turn_button: Button = %EndTurnButton
@onready var restart_button: Button = %RestartButton

var mode := "move"
var selected_target := Vector2i(-1, -1)
var history: Array[String] = []
var is_animating := false
var world_return_enabled := false
var world_encounter_id := ""
var auto_return_delay := 0.75


func configure_hero(hero_id: String) -> void:
	combat_state.configure_hero(hero_id)


func enable_world_return(encounter_id: String) -> void:
	world_return_enabled = true
	world_encounter_id = encounter_id


func _ready() -> void:
	combat_state.obstacles = board.editor_obstacles.duplicate()
	board.set_combat_state(combat_state)
	var hero_definition := HeroCatalogScript.get_definition(combat_state.hero_class_id)
	instruction_label.text = "Touchez une tuile marquée M pour avancer. Choisissez %s puis touchez Moss Slime pour attaquer." % combat_state.player_basic_skill_name
	attack_button.text = "%s · 1 AP" % combat_state.player_basic_skill_name
	attack_button.icon = hero_definition.skill_icon
	attack_button.tooltip_text = "Attaque de portée %d. Choisissez le sort puis touchez directement Moss Slime." % combat_state.player_basic_skill_range
	move_button.pressed.connect(_on_move_pressed)
	attack_button.pressed.connect(_on_attack_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	board.cell_pressed.connect(_on_cell_pressed)
	board.sync_visual_positions()
	_append_log("Combat commencé. %s joue en premier." % combat_state.player_display_name)
	_refresh_interface()
	call_deferred("_focus_board")


func _focus_board() -> void:
	board.grab_focus()
	board.set_focus_cell(combat_state.player_position)


func _on_cell_pressed(cell: Vector2i) -> void:
	if is_animating:
		return
	if combat_state.is_game_over:
		status_label.text = "Le combat est terminé. Choisissez Recommencer."
		return
	if not combat_state.is_player_turn:
		status_label.text = "Moss Slime joue son tour."
		return

	if mode == "attack":
		if cell != combat_state.enemy_position:
			status_label.text = "%s doit cibler Moss Slime." % combat_state.player_basic_skill_name
			return
		if not combat_state.can_use_basic_attack(cell):
			status_label.text = _basic_attack_blocked_message()
			return
		selected_target = cell
		status_label.text = "%s cible Moss Slime…" % combat_state.player_basic_skill_name
		await _execute_basic_attack()
		return

	var result := combat_state.try_player_move(cell)
	if result.get("ok", false):
		is_animating = true
		status_label.text = "%s se déplace…" % combat_state.player_display_name
		_refresh_interface(false)
		await board.animate_unit_path("player", result.path)
		_append_log("%s se déplace de %d case(s) vers %s." % [combat_state.player_display_name, result.cost, _cell_name(result.to)])
		status_label.text = "Déplacement validé. Il reste %d MP." % combat_state.player_mp
		is_animating = false
	else:
		status_label.text = result.get("reason", "Déplacement impossible.")
	_refresh_interface(false)


func _on_move_pressed() -> void:
	if is_animating or combat_state.is_game_over:
		return
	mode = "move"
	selected_target = Vector2i(-1, -1)
	status_label.text = "Mode déplacement : choisissez une tuile marquée M."
	_refresh_interface(false)


func _on_attack_pressed() -> void:
	if attack_button.disabled or is_animating:
		return
	mode = "attack"
	selected_target = Vector2i(-1, -1)
	if combat_state.can_use_basic_attack():
		status_label.text = "Touchez Moss Slime pour afficher les dégâts exacts."
	else:
		status_label.text = _basic_attack_blocked_message()
	_refresh_interface(false)


func _execute_claw_strike() -> void:
	await _execute_basic_attack()


func _execute_basic_attack() -> void:
	var result := combat_state.player_basic_attack(selected_target)
	if not result.get("ok", false):
		status_label.text = result.get("reason", "Attaque impossible.")
		return

	is_animating = true
	mode = "move"
	selected_target = Vector2i(-1, -1)
	status_label.text = "%s !" % result.skill
	_refresh_interface(false)
	await board.animate_player_attack(result.damage)
	_append_log("%s inflige %d dégâts à Moss Slime." % [result.skill, result.damage])
	var should_auto_return: bool = result.get("victory", false) and world_return_enabled
	if result.get("victory", false):
		await board.animate_victory()
		_append_log("Victoire : Moss Slime est vaincu.")
		status_label.text = "Victoire ! Retour à Whispering Woods…" if should_auto_return else "Victoire ! Le premier combat hors ligne est terminé."
	else:
		status_label.text = "Attaque validée. Moss Slime a encore %d PV." % combat_state.enemy_health
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
	selected_target = Vector2i(-1, -1)
	status_label.text = "Sélection annulée. Choisissez une tuile marquée M."
	_refresh_interface(false)


func _on_end_turn_pressed() -> void:
	if is_animating:
		return
	var result := combat_state.end_player_turn()
	if not result.get("ok", false):
		status_label.text = result.get("reason", "Impossible de terminer le tour.")
		return

	is_animating = true
	mode = "move"
	selected_target = Vector2i(-1, -1)
	status_label.text = "Tour de Moss Slime…"
	_refresh_interface(false)
	for event in result.events:
		match event.get("type", ""):
			"enemy_move":
				await board.animate_unit_path("enemy", event.path)
				_append_log("Moss Slime se déplace de %d case(s) vers %s." % [event.cost, _cell_name(event.to)])
			"enemy_attack":
				await board.animate_soft_bump(event.damage)
				_append_log("Soft Bump inflige %d dégâts à %s." % [event.damage, combat_state.player_display_name])
			"defeat":
				await board.animate_defeat()
				_append_log("Défaite : %s n'a plus de PV." % combat_state.player_display_name)

	if combat_state.outcome == "defeat":
		status_label.text = "Défaite. Recommencez pour essayer une autre approche."
	else:
		status_label.text = "Tour %d : %s récupère 3 AP et 3 MP." % [combat_state.turn_number, combat_state.player_display_name]
	is_animating = false
	_refresh_interface(false)


func _on_restart_pressed() -> void:
	if is_animating:
		return
	if world_return_enabled and combat_state.is_game_over:
		battle_finished.emit(combat_state.outcome, world_encounter_id)
		return
	combat_state.reset()
	mode = "move"
	selected_target = Vector2i(-1, -1)
	history.clear()
	_append_log("Nouveau combat. %s joue en premier." % combat_state.player_display_name)
	status_label.text = "Touchez une tuile marquée M pour commencer."
	board.set_focus_cell(combat_state.player_position)
	board.sync_visual_positions()
	_refresh_interface(false)


func _refresh_interface(reset_status: bool = true) -> void:
	turn_label.text = "Tour %d · %s" % [
		combat_state.turn_number,
		combat_state.player_display_name if combat_state.is_player_turn else "Moss Slime",
	]
	stats_label.text = (
		"%s  ·  PV %d/%d  ·  AP %d/3  ·  MP %d/3\n"
		+ "Moss Slime       ·  PV %d/%d"
	) % [
		combat_state.player_display_name,
		combat_state.player_health,
		combat_state.player_max_health,
		combat_state.player_ap,
		combat_state.player_mp,
		combat_state.enemy_health,
		combat_state.ENEMY_MAX_HEALTH,
	]

	var player_can_act: bool = combat_state.is_player_turn and not combat_state.is_game_over and not is_animating
	move_button.disabled = not player_can_act or mode == "move"
	attack_button.disabled = not player_can_act or combat_state.player_ap < 1
	end_turn_button.disabled = not player_can_act
	cancel_button.visible = player_can_act and mode == "attack"
	restart_button.disabled = is_animating
	if world_return_enabled:
		restart_button.visible = combat_state.is_game_over and combat_state.outcome != "victory"
		restart_button.text = "Retourner à Whispering Woods"
	else:
		restart_button.visible = true
		restart_button.text = "Recommencer"

	var legal_movement_cells: Array[Vector2i] = []
	if player_can_act and mode == "move":
		legal_movement_cells = combat_state.get_reachable_player_cells()
	board.movement_cells = legal_movement_cells

	var legal_attack_cells: Array[Vector2i] = []
	if player_can_act and mode == "attack" and combat_state.can_use_basic_attack():
		legal_attack_cells.append(combat_state.enemy_position)
	board.attack_cells = legal_attack_cells
	board.selected_cell = selected_target
	board.is_animating = is_animating
	board.set_combat_state(combat_state)

	if reset_status:
		if combat_state.is_game_over:
			status_label.text = "Victoire !" if combat_state.outcome == "victory" else "Défaite."
		elif mode == "move":
			status_label.text = "Déplacement : choisissez une tuile marquée M."
	_update_log_text()


func _append_log(message: String) -> void:
	history.append(message)
	if history.size() > 8:
		history.pop_front()
	_update_log_text()


func _update_log_text() -> void:
	if log_label != null:
		log_label.text = "\n".join(history)


func _cell_name(cell: Vector2i) -> String:
	return "%s%d" % [String.chr(65 + cell.x), cell.y + 1]


func _basic_attack_blocked_message() -> String:
	if combat_state.manhattan_distance(combat_state.player_position, combat_state.enemy_position) > combat_state.player_basic_skill_range:
		return "Moss Slime est hors de portée (%d cases)." % combat_state.player_basic_skill_range
	if combat_state.player_requires_line_of_sight and not combat_state.has_line_of_sight(combat_state.player_position, combat_state.enemy_position):
		return "Un pilier bloque la ligne de vue. Déplacez %s avant d'attaquer." % combat_state.player_display_name
	return "%s n'est pas disponible maintenant." % combat_state.player_basic_skill_name


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
		KEY_A:
			_on_attack_pressed()
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
