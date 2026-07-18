extends Control

const CombatStateScript = preload("res://scripts/combat/combat_state.gd")
const BattleBoardScript = preload("res://scripts/poc/battle_board.gd")
const ARENA_BACKGROUND: Texture2D = preload("res://assets/backgrounds/whispering_woods_arena_v1.png")
const ICON_CLAW_STRIKE: Texture2D = preload("res://assets/ui/icons/claw_strike.png")
const ICON_END_TURN: Texture2D = preload("res://assets/ui/icons/end_turn.png")
const ICON_MOVE: Texture2D = preload("res://assets/ui/icons/move.png")
const ICON_CONFIRM: Texture2D = preload("res://assets/ui/icons/confirm.png")
const ICON_CANCEL: Texture2D = preload("res://assets/ui/icons/cancel.png")
const ICON_RESTART: Texture2D = preload("res://assets/ui/icons/restart.png")

var combat_state = CombatStateScript.new()
var board
var background_texture: TextureRect
var side_panel: PanelContainer
var turn_label: Label
var stats_label: Label
var status_label: Label
var instruction_label: Label
var log_label: RichTextLabel
var move_button: Button
var attack_button: Button
var confirm_button: Button
var cancel_button: Button
var end_turn_button: Button
var restart_button: Button

var mode := "move"
var selected_target := Vector2i(-1, -1)
var history: Array[String] = []
var is_animating := false


func _ready() -> void:
	_build_interface()
	resized.connect(_layout_interface)
	board.cell_pressed.connect(_on_cell_pressed)
	board.sync_visual_positions()
	_append_log("Combat commencé. Wolf Guardian joue en premier.")
	_refresh_interface()
	call_deferred("_layout_interface")
	call_deferred("_focus_board")


func _build_interface() -> void:
	background_texture = TextureRect.new()
	background_texture.name = "WhisperingWoodsBackground"
	background_texture.texture = ARENA_BACKGROUND
	background_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background_texture.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background_texture)

	var atmosphere := ColorRect.new()
	atmosphere.color = Color(0.015, 0.055, 0.065, 0.30)
	atmosphere.mouse_filter = Control.MOUSE_FILTER_IGNORE
	atmosphere.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(atmosphere)

	board = BattleBoardScript.new()
	board.name = "BattleBoard"
	board.set_combat_state(combat_state)
	add_child(board)

	side_panel = PanelContainer.new()
	side_panel.name = "CombatHUD"
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.035, 0.085, 0.10, 0.94)
	panel_style.border_color = Color("#72b69f")
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(18)
	panel_style.shadow_color = Color(0, 0, 0, 0.48)
	panel_style.shadow_size = 12
	panel_style.shadow_offset = Vector2(-4, 6)
	side_panel.add_theme_stylebox_override("panel", panel_style)
	add_child(side_panel)

	var margin_container := MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", 20)
	margin_container.add_theme_constant_override("margin_top", 17)
	margin_container.add_theme_constant_override("margin_right", 20)
	margin_container.add_theme_constant_override("margin_bottom", 17)
	side_panel.add_child(margin_container)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin_container.add_child(scroll)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 9)
	scroll.add_child(content)

	var title := Label.new()
	title.text = "WILDBOUND"
	title.add_theme_font_size_override("font_size", 29)
	title.add_theme_color_override("font_color", Color("#d5fff0"))
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.72))
	title.add_theme_constant_override("shadow_offset_x", 2)
	title.add_theme_constant_override("shadow_offset_y", 3)
	content.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Whispering Woods · Combat isométrique 2.5D"
	subtitle.add_theme_font_size_override("font_size", 15)
	subtitle.add_theme_color_override("font_color", Color("#93d6c4"))
	content.add_child(subtitle)
	content.add_child(HSeparator.new())

	turn_label = _make_label(21)
	turn_label.add_theme_color_override("font_color", Color("#ffe09a"))
	content.add_child(turn_label)
	stats_label = _make_label(16)
	stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(stats_label)

	instruction_label = _make_label(15)
	instruction_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	instruction_label.text = "Touchez une tuile marquée M pour avancer. Utilisez Claw Strike quand Moss Slime est adjacent."
	instruction_label.add_theme_color_override("font_color", Color("#d6ebe5"))
	content.add_child(instruction_label)

	move_button = _make_button("Déplacement", Color("#31585b"), ICON_MOVE)
	move_button.tooltip_text = "Quitte le ciblage d'une compétence et revient au déplacement."
	move_button.pressed.connect(_on_move_pressed)
	content.add_child(move_button)

	attack_button = _make_button("Claw Strike · 1 AP", Color("#245d55"), ICON_CLAW_STRIKE)
	attack_button.tooltip_text = "Attaque de portée 1. Les dégâts exacts sont affichés avant confirmation."
	attack_button.pressed.connect(_on_attack_pressed)
	content.add_child(attack_button)

	confirm_button = _make_button("Confirmer l'attaque", Color("#8a4b32"), ICON_CONFIRM)
	confirm_button.pressed.connect(_on_confirm_attack_pressed)
	content.add_child(confirm_button)

	cancel_button = _make_button("Annuler la sélection", Color("#3a4d55"), ICON_CANCEL)
	cancel_button.pressed.connect(_on_cancel_pressed)
	content.add_child(cancel_button)

	end_turn_button = _make_button("Terminer le tour", Color("#344d66"), ICON_END_TURN)
	end_turn_button.tooltip_text = "Passe la main à Moss Slime. Les AP et MP restants sont perdus."
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	content.add_child(end_turn_button)

	status_label = _make_label(16)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_color_override("font_color", Color("#ffe08a"))
	content.add_child(status_label)
	content.add_child(HSeparator.new())

	var log_title := _make_label(16)
	log_title.text = "Journal du combat"
	content.add_child(log_title)
	log_label = RichTextLabel.new()
	log_label.custom_minimum_size = Vector2(0, 100)
	log_label.fit_content = true
	log_label.scroll_active = false
	log_label.add_theme_font_size_override("normal_font_size", 14)
	log_label.add_theme_color_override("default_color", Color("#bed4ce"))
	content.add_child(log_label)

	restart_button = _make_button("Recommencer", Color("#4b3e67"), ICON_RESTART)
	restart_button.pressed.connect(_on_restart_pressed)
	content.add_child(restart_button)

	var keyboard_help := _make_label(13)
	keyboard_help.text = "Clavier : flèches + Entrée · A attaque · E termine · R recommence"
	keyboard_help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	keyboard_help.add_theme_color_override("font_color", Color("#8fa9a2"))
	content.add_child(keyboard_help)


func _make_label(font_size: int) -> Label:
	var label := Label.new()
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _make_button(text_value: String, background_color: Color, icon_texture: Texture2D) -> Button:
	var button := Button.new()
	button.text = text_value
	button.icon = icon_texture
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.custom_minimum_size = Vector2(0, 56)
	button.add_theme_font_size_override("font_size", 17)
	button.focus_mode = Control.FOCUS_ALL
	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = background_color
	normal_style.border_color = background_color.lightened(0.28)
	normal_style.set_border_width_all(2)
	normal_style.set_corner_radius_all(12)
	normal_style.content_margin_left = 15
	normal_style.content_margin_right = 15
	var hover_style := normal_style.duplicate() as StyleBoxFlat
	hover_style.bg_color = background_color.lightened(0.12)
	var pressed_style := normal_style.duplicate() as StyleBoxFlat
	pressed_style.bg_color = background_color.darkened(0.12)
	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", pressed_style)
	button.add_theme_stylebox_override("focus", hover_style)
	return button


func _layout_interface() -> void:
	if board == null or side_panel == null:
		return
	var viewport_size: Vector2 = size
	var margin: float = clampf(minf(viewport_size.x, viewport_size.y) * 0.025, 10.0, 20.0)
	var desired_panel_width: float = clampf(viewport_size.x * 0.315, 310.0, 410.0)
	var board_width: float = maxf(300.0, viewport_size.x - desired_panel_width - margin * 3.0)
	board.position = Vector2(margin, margin)
	board.size = Vector2(board_width, viewport_size.y - margin * 2.0)

	var panel_x: float = board.position.x + board_width + margin
	side_panel.position = Vector2(panel_x, margin)
	side_panel.size = Vector2(maxf(280.0, viewport_size.x - panel_x - margin), viewport_size.y - margin * 2.0)
	board.queue_redraw()


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
			status_label.text = "Claw Strike doit cibler Moss Slime."
			return
		if not combat_state.can_use_claw_strike(cell):
			status_label.text = "Cible hors de portée : placez Wolf Guardian sur une case adjacente."
			return
		if selected_target == cell:
			await _execute_claw_strike()
			return
		selected_target = cell
		status_label.text = "Prévision : %d dégâts. Confirmez ou touchez encore Moss Slime." % combat_state.preview_claw_strike_damage()
		_refresh_interface(false)
		return

	var result := combat_state.try_player_move(cell)
	if result.get("ok", false):
		is_animating = true
		status_label.text = "Wolf Guardian se déplace…"
		_refresh_interface(false)
		await board.animate_unit_path("player", result.path)
		_append_log("Wolf Guardian se déplace de %d case(s) vers %s." % [result.cost, _cell_name(result.to)])
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
	if combat_state.can_use_claw_strike():
		status_label.text = "Touchez Moss Slime pour afficher les dégâts exacts."
	else:
		status_label.text = "Moss Slime est hors de portée. Annulez puis rapprochez-vous."
	_refresh_interface(false)


func _on_confirm_attack_pressed() -> void:
	if selected_target == combat_state.enemy_position and not is_animating:
		await _execute_claw_strike()


func _execute_claw_strike() -> void:
	var result := combat_state.player_claw_strike(selected_target)
	if not result.get("ok", false):
		status_label.text = result.get("reason", "Attaque impossible.")
		return

	is_animating = true
	mode = "move"
	selected_target = Vector2i(-1, -1)
	status_label.text = "Claw Strike !"
	_refresh_interface(false)
	await board.animate_claw_strike(result.damage)
	_append_log("Claw Strike inflige %d dégâts à Moss Slime." % result.damage)
	if result.get("victory", false):
		await board.animate_victory()
		_append_log("Victoire : Moss Slime est vaincu.")
		status_label.text = "Victoire ! Le premier combat hors ligne est terminé."
	else:
		status_label.text = "Attaque validée. Moss Slime a encore %d PV." % combat_state.enemy_health
	is_animating = false
	_refresh_interface(false)


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
				_append_log("Soft Bump inflige %d dégâts à Wolf Guardian." % event.damage)
			"defeat":
				await board.animate_defeat()
				_append_log("Défaite : Wolf Guardian n'a plus de PV.")

	if combat_state.outcome == "defeat":
		status_label.text = "Défaite. Recommencez pour essayer une autre approche."
	else:
		status_label.text = "Tour %d : Wolf Guardian récupère 3 AP et 3 MP." % combat_state.turn_number
	is_animating = false
	_refresh_interface(false)


func _on_restart_pressed() -> void:
	if is_animating:
		return
	combat_state.reset()
	mode = "move"
	selected_target = Vector2i(-1, -1)
	history.clear()
	_append_log("Nouveau combat. Wolf Guardian joue en premier.")
	status_label.text = "Touchez une tuile marquée M pour commencer."
	board.set_focus_cell(combat_state.player_position)
	board.sync_visual_positions()
	_refresh_interface(false)


func _refresh_interface(reset_status: bool = true) -> void:
	turn_label.text = "Tour %d · %s" % [
		combat_state.turn_number,
		"Wolf Guardian" if combat_state.is_player_turn else "Moss Slime",
	]
	stats_label.text = (
		"Wolf Guardian  ·  PV %d/%d  ·  AP %d/3  ·  MP %d/3\n"
		+ "Moss Slime       ·  PV %d/%d"
	) % [
		combat_state.player_health,
		combat_state.PLAYER_MAX_HEALTH,
		combat_state.player_ap,
		combat_state.player_mp,
		combat_state.enemy_health,
		combat_state.ENEMY_MAX_HEALTH,
	]

	var player_can_act: bool = combat_state.is_player_turn and not combat_state.is_game_over and not is_animating
	move_button.disabled = not player_can_act or mode == "move"
	attack_button.disabled = not player_can_act or combat_state.player_ap < 1
	end_turn_button.disabled = not player_can_act
	confirm_button.visible = player_can_act and mode == "attack" and selected_target == combat_state.enemy_position
	cancel_button.visible = player_can_act and mode == "attack"
	restart_button.disabled = is_animating

	var legal_movement_cells: Array[Vector2i] = []
	if player_can_act and mode == "move":
		legal_movement_cells = combat_state.get_reachable_player_cells()
	board.movement_cells = legal_movement_cells

	var legal_attack_cells: Array[Vector2i] = []
	if player_can_act and mode == "attack" and combat_state.can_use_claw_strike():
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
