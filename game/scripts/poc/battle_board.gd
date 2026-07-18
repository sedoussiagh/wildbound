@tool
class_name BattleBoard
extends Control

signal cell_pressed(cell: Vector2i)

const HeroCatalogScript = preload("res://scripts/characters/hero_catalog.gd")
const GRID_SIZE := 7
const SLIME_WALK_FRAMES := [
	preload("res://assets/characters/moss_slime/walk_0.png"),
	preload("res://assets/characters/moss_slime/walk_1.png"),
	preload("res://assets/characters/moss_slime/walk_2.png"),
	preload("res://assets/characters/moss_slime/walk_3.png"),
]
const SLIME_ATTACK_FRAMES := [
	preload("res://assets/characters/moss_slime/attack_0.png"),
	preload("res://assets/characters/moss_slime/attack_1.png"),
	preload("res://assets/characters/moss_slime/attack_2.png"),
	preload("res://assets/characters/moss_slime/attack_3.png"),
]

@export_category("Editor Preview")
@export var editor_obstacles: Array[Vector2i] = [Vector2i(3, 2), Vector2i(3, 3)]
@export var even_tile_color := Color(0.13, 0.34, 0.24, 0.11)
@export var odd_tile_color := Color(0.24, 0.44, 0.27, 0.07)
@export var grid_line_color := Color(0.80, 0.96, 0.73, 0.30)

var combat_state
var movement_cells: Array[Vector2i] = []
var attack_cells: Array[Vector2i] = []
var selected_cell := Vector2i(-1, -1)
var focus_cell := Vector2i(1, 3)
var hover_cell := Vector2i(-1, -1)
var is_animating := false

var player_visual_grid := Vector2(1, 3):
	set(value):
		player_visual_grid = value
		queue_redraw()
var enemy_visual_grid := Vector2(5, 3):
	set(value):
		enemy_visual_grid = value
		queue_redraw()
var player_offset := Vector2.ZERO:
	set(value):
		player_offset = value
		queue_redraw()
var enemy_offset := Vector2.ZERO:
	set(value):
		enemy_offset = value
		queue_redraw()
var player_scale := Vector2.ONE:
	set(value):
		player_scale = value
		queue_redraw()
var enemy_scale := Vector2.ONE:
	set(value):
		enemy_scale = value
		queue_redraw()
var player_bounce := 0.0:
	set(value):
		player_bounce = value
		queue_redraw()
var enemy_bounce := 0.0:
	set(value):
		enemy_bounce = value
		queue_redraw()
var player_flash := 0.0:
	set(value):
		player_flash = value
		queue_redraw()
var enemy_flash := 0.0:
	set(value):
		enemy_flash = value
		queue_redraw()
var slash_strength := 0.0:
	set(value):
		slash_strength = value
		queue_redraw()
var spark_strength := 0.0:
	set(value):
		spark_strength = value
		queue_redraw()
var spark_progress := 0.0:
	set(value):
		spark_progress = value
		queue_redraw()
var player_alpha := 1.0:
	set(value):
		player_alpha = value
		queue_redraw()
var enemy_alpha := 1.0:
	set(value):
		enemy_alpha = value
		queue_redraw()

var _board_origin := Vector2.ZERO
var _tile_width := 76.0
var _tile_height := 39.0
var _animation_clock := 0.0
var _player_animation := "idle"
var _enemy_animation := "idle"
var _player_frame := 0
var _enemy_frame := 0


func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	tooltip_text = "Plateau tactique isométrique 7 par 7. Utilisez le toucher, la souris ou les flèches."
	set_process(true)


func _process(delta: float) -> void:
	_animation_clock += delta
	if _player_animation == "walk":
		_player_frame = int(floor(_animation_clock * 9.0)) % _player_walk_frames().size()
	if _enemy_animation == "walk":
		_enemy_frame = int(floor(_animation_clock * 8.0)) % SLIME_WALK_FRAMES.size()
	queue_redraw()


func set_combat_state(value) -> void:
	combat_state = value
	queue_redraw()


func sync_visual_positions() -> void:
	if combat_state == null:
		return
	player_visual_grid = Vector2(combat_state.player_position)
	enemy_visual_grid = Vector2(combat_state.enemy_position)
	player_offset = Vector2.ZERO
	enemy_offset = Vector2.ZERO
	player_scale = Vector2.ONE
	enemy_scale = Vector2.ONE
	player_alpha = 1.0
	enemy_alpha = 1.0
	player_flash = 0.0
	enemy_flash = 0.0
	slash_strength = 0.0
	spark_strength = 0.0
	spark_progress = 0.0
	_player_animation = "idle"
	_enemy_animation = "idle"
	_player_frame = 0
	_enemy_frame = 0


func set_focus_cell(cell: Vector2i) -> void:
	focus_cell = Vector2i(clamp(cell.x, 0, GRID_SIZE - 1), clamp(cell.y, 0, GRID_SIZE - 1))
	tooltip_text = get_cell_description(focus_cell)
	queue_redraw()


func get_cell_description(cell: Vector2i) -> String:
	var coordinate := "%s%d" % [String.chr(65 + cell.x), cell.y + 1]
	if combat_state == null:
		return "Case %s" % coordinate
	if cell == combat_state.player_position:
		return "Case %s, %s, %d points de vie." % [coordinate, combat_state.player_display_name, combat_state.player_health]
	if cell == combat_state.enemy_position:
		return "Case %s, Moss Slime, %d points de vie." % [coordinate, combat_state.enemy_health]
	if cell in combat_state.obstacles:
		return "Case %s, pilier de pierre infranchissable." % coordinate
	if cell in movement_cells:
		return "Case %s, déplacement légal." % coordinate
	return "Case %s, libre." % coordinate


func animate_unit_path(unit_name: String, path: Array) -> void:
	if path.size() < 2:
		return
	is_animating = true
	if unit_name == "player":
		_player_animation = "walk"
		_player_frame = 0
	else:
		_enemy_animation = "walk"
		_enemy_frame = 0
	var grid_property := "player_visual_grid" if unit_name == "player" else "enemy_visual_grid"
	var bounce_property := "player_bounce" if unit_name == "player" else "enemy_bounce"
	for index in range(1, path.size()):
		var step_tween := create_tween().set_parallel(true)
		step_tween.tween_property(self, grid_property, Vector2(path[index]), 0.17).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		step_tween.tween_property(self, bounce_property, -10.0, 0.09).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await step_tween.finished
		var landing_tween := create_tween()
		landing_tween.tween_property(self, bounce_property, 0.0, 0.08).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		await landing_tween.finished
	if unit_name == "player":
		_player_animation = "idle"
		_player_frame = 0
	else:
		_enemy_animation = "idle"
		_enemy_frame = 0
	is_animating = false


func animate_claw_strike(damage: int) -> void:
	is_animating = true
	_player_animation = "attack"
	_player_frame = 0
	var from_point := _project_grid(player_visual_grid)
	var target_point := _project_grid(enemy_visual_grid)
	var direction := (target_point - from_point).normalized()
	var lunge := direction * minf(_tile_width * 0.42, 36.0) + Vector2(0, -8)

	var windup := create_tween().set_parallel(true)
	windup.tween_property(self, "player_offset", -direction * 10.0 + Vector2(0, 3), 0.10).set_trans(Tween.TRANS_QUAD)
	windup.tween_property(self, "player_scale", Vector2(0.94, 1.06), 0.10)
	await windup.finished
	_player_frame = 1

	var strike := create_tween().set_parallel(true)
	strike.tween_property(self, "player_offset", lunge, 0.11).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	strike.tween_property(self, "player_scale", Vector2(1.08, 0.94), 0.11)
	await strike.finished
	_player_frame = 2

	slash_strength = 1.0
	enemy_flash = 1.0
	show_damage_popup("enemy", damage)
	var impact_direction := direction if direction.length() > 0.0 else Vector2.RIGHT
	var impact := create_tween().set_parallel(true)
	impact.tween_property(self, "enemy_offset", impact_direction * 14.0, 0.06)
	impact.tween_property(self, "enemy_scale", Vector2(1.12, 0.88), 0.08)
	impact.tween_property(self, "slash_strength", 0.0, 0.28)
	impact.tween_property(self, "enemy_flash", 0.0, 0.24)
	await impact.finished

	_player_frame = 3
	var recover := create_tween().set_parallel(true)
	recover.tween_property(self, "player_offset", Vector2.ZERO, 0.18).set_trans(Tween.TRANS_SINE)
	recover.tween_property(self, "player_scale", Vector2.ONE, 0.18)
	recover.tween_property(self, "enemy_offset", Vector2.ZERO, 0.14).set_trans(Tween.TRANS_ELASTIC)
	recover.tween_property(self, "enemy_scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BOUNCE)
	await recover.finished
	_player_animation = "idle"
	_player_frame = 0
	is_animating = false


func animate_player_attack(damage: int) -> void:
	if combat_state.player_basic_skill_name == "Spark Bolt":
		await animate_spark_bolt(damage)
	else:
		await animate_claw_strike(damage)


func animate_spark_bolt(damage: int) -> void:
	is_animating = true
	_player_animation = "attack"
	_player_frame = 0

	var windup := create_tween().set_parallel(true)
	windup.tween_property(self, "player_scale", Vector2(0.94, 1.08), 0.12).set_trans(Tween.TRANS_QUAD)
	windup.tween_property(self, "player_bounce", -7.0, 0.12).set_trans(Tween.TRANS_QUAD)
	await windup.finished
	_player_frame = 1
	spark_strength = 1.0
	spark_progress = 0.0

	var cast := create_tween().set_parallel(true)
	cast.tween_property(self, "spark_progress", 1.0, 0.30).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	cast.tween_property(self, "player_scale", Vector2(1.06, 0.96), 0.18).set_trans(Tween.TRANS_BACK)
	await cast.finished
	_player_frame = 2
	enemy_flash = 1.0
	show_damage_popup("enemy", damage)

	var impact_direction := (_project_grid(enemy_visual_grid) - _project_grid(player_visual_grid)).normalized()
	var impact := create_tween().set_parallel(true)
	impact.tween_property(self, "enemy_offset", impact_direction * 14.0, 0.08)
	impact.tween_property(self, "enemy_scale", Vector2(1.12, 0.88), 0.09)
	impact.tween_property(self, "enemy_flash", 0.0, 0.24)
	impact.tween_property(self, "spark_strength", 0.0, 0.20)
	await impact.finished

	_player_frame = 3
	var recover := create_tween().set_parallel(true)
	recover.tween_property(self, "player_scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_SINE)
	recover.tween_property(self, "player_bounce", 0.0, 0.18).set_trans(Tween.TRANS_BOUNCE)
	recover.tween_property(self, "enemy_offset", Vector2.ZERO, 0.14).set_trans(Tween.TRANS_ELASTIC)
	recover.tween_property(self, "enemy_scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BOUNCE)
	await recover.finished
	spark_progress = 0.0
	_player_animation = "idle"
	_player_frame = 0
	is_animating = false


func animate_soft_bump(damage: int) -> void:
	is_animating = true
	_enemy_animation = "attack"
	_enemy_frame = 0
	var from_point := _project_grid(enemy_visual_grid)
	var target_point := _project_grid(player_visual_grid)
	var direction := (target_point - from_point).normalized()
	var windup := create_tween().set_parallel(true)
	windup.tween_property(self, "enemy_scale", Vector2(1.16, 0.78), 0.10)
	windup.tween_property(self, "enemy_offset", -direction * 7.0 + Vector2(0, 5), 0.10)
	await windup.finished
	_enemy_frame = 1

	var bump := create_tween().set_parallel(true)
	bump.tween_property(self, "enemy_offset", direction * minf(_tile_width * 0.34, 28.0), 0.10).set_trans(Tween.TRANS_BACK)
	bump.tween_property(self, "enemy_scale", Vector2(0.90, 1.15), 0.10)
	await bump.finished
	_enemy_frame = 2

	player_flash = 1.0
	show_damage_popup("player", damage)
	var hit := create_tween().set_parallel(true)
	hit.tween_property(self, "player_offset", direction * 10.0, 0.06)
	hit.tween_property(self, "player_flash", 0.0, 0.22)
	await hit.finished

	_enemy_frame = 3
	var recover := create_tween().set_parallel(true)
	recover.tween_property(self, "enemy_offset", Vector2.ZERO, 0.14)
	recover.tween_property(self, "enemy_scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BOUNCE)
	recover.tween_property(self, "player_offset", Vector2.ZERO, 0.12).set_trans(Tween.TRANS_ELASTIC)
	await recover.finished
	_enemy_animation = "idle"
	_enemy_frame = 0
	is_animating = false


func animate_victory() -> void:
	is_animating = true
	var fade := create_tween().set_parallel(true)
	fade.tween_property(self, "enemy_alpha", 0.0, 0.42).set_trans(Tween.TRANS_QUAD)
	fade.tween_property(self, "enemy_scale", Vector2(0.45, 0.45), 0.42).set_trans(Tween.TRANS_BACK)
	fade.tween_property(self, "enemy_bounce", -24.0, 0.42)
	await fade.finished
	var celebrate := create_tween()
	celebrate.tween_property(self, "player_bounce", -18.0, 0.16).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	celebrate.tween_property(self, "player_bounce", 0.0, 0.22).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await celebrate.finished
	is_animating = false


func animate_defeat() -> void:
	is_animating = true
	var fade := create_tween().set_parallel(true)
	fade.tween_property(self, "player_alpha", 0.45, 0.38)
	fade.tween_property(self, "player_scale", Vector2(1.15, 0.55), 0.38).set_trans(Tween.TRANS_BOUNCE)
	await fade.finished
	is_animating = false


func show_damage_popup(unit_name: String, damage: int) -> void:
	var label := Label.new()
	label.text = "-%d" % damage
	label.add_theme_font_size_override("font_size", 28)
	label.add_theme_color_override("font_color", Color("#fff2c2"))
	label.add_theme_color_override("font_outline_color", Color("#5a1717"))
	label.add_theme_constant_override("outline_size", 7)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var grid_position := player_visual_grid if unit_name == "player" else enemy_visual_grid
	label.position = _project_grid(grid_position) + Vector2(-35, -105)
	label.size = Vector2(70, 40)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(label, "position", label.position + Vector2(0, -48), 0.62).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 0.62).set_delay(0.20)
	tween.finished.connect(func() -> void: label.queue_free())


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		hover_cell = _cell_from_local_position(event.position)
		queue_redraw()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_submit_position(event.position)
	elif event is InputEventScreenTouch and event.pressed:
		_submit_position(event.position)


func _submit_position(local_position: Vector2) -> void:
	if is_animating:
		return
	var cell := _cell_from_local_position(local_position)
	if cell.x < 0:
		return
	set_focus_cell(cell)
	grab_focus()
	cell_pressed.emit(cell)


func _cell_from_local_position(local_position: Vector2) -> Vector2i:
	_update_projection()
	var relative := local_position - _board_origin
	var half_width := _tile_width * 0.5
	var half_height := _tile_height * 0.5
	var grid_x_float := (relative.x / half_width + relative.y / half_height) * 0.5
	var grid_y_float := (relative.y / half_height - relative.x / half_width) * 0.5
	var candidate := Vector2i(roundi(grid_x_float), roundi(grid_y_float))
	if candidate.x < 0 or candidate.x >= GRID_SIZE or candidate.y < 0 or candidate.y >= GRID_SIZE:
		return Vector2i(-1, -1)
	var center := _project_cell(candidate)
	var local_delta := local_position - center
	var diamond_distance := absf(local_delta.x) / half_width + absf(local_delta.y) / half_height
	return candidate if diamond_distance <= 1.0 else Vector2i(-1, -1)


func _draw() -> void:
	_update_projection()
	_draw_ambient_magic()

	for depth in range(GRID_SIZE * 2 - 1):
		for y in range(GRID_SIZE):
			for x in range(GRID_SIZE):
				if x + y != depth:
					continue
				_draw_tile(Vector2i(x, y))

	for depth in range(GRID_SIZE * 2 - 1):
		for obstacle in combat_state.obstacles if combat_state != null else editor_obstacles:
			if obstacle.x + obstacle.y == depth:
				_draw_obstacle(obstacle)

	if combat_state != null:
		var player_depth := player_visual_grid.x + player_visual_grid.y
		var enemy_depth := enemy_visual_grid.x + enemy_visual_grid.y
		if player_depth <= enemy_depth:
			_draw_player()
			_draw_enemy()
		else:
			_draw_enemy()
			_draw_player()
		_draw_combat_effects()
	elif Engine.is_editor_hint():
		_draw_editor_units()


func _update_projection() -> void:
	_tile_width = minf(size.x / 8.0, size.y / 6.5)
	_tile_width = maxf(_tile_width, 42.0)
	_tile_height = _tile_width * 0.52
	_board_origin = Vector2(size.x * 0.50, size.y * 0.20)


func _project_cell(cell: Vector2i) -> Vector2:
	return _project_grid(Vector2(cell))


func _project_grid(grid_position: Vector2) -> Vector2:
	return _board_origin + Vector2(
		(grid_position.x - grid_position.y) * _tile_width * 0.5,
		(grid_position.x + grid_position.y) * _tile_height * 0.5
	)


func _diamond(center: Vector2, vertical_offset: float = 0.0) -> PackedVector2Array:
	var shifted := center + Vector2(0, vertical_offset)
	return PackedVector2Array([
		shifted + Vector2(0, -_tile_height * 0.5),
		shifted + Vector2(_tile_width * 0.5, 0),
		shifted + Vector2(0, _tile_height * 0.5),
		shifted + Vector2(-_tile_width * 0.5, 0),
	])


func _closed_diamond(center: Vector2, inset_scale: float = 1.0) -> PackedVector2Array:
	var half_width := _tile_width * 0.5 * inset_scale
	var half_height := _tile_height * 0.5 * inset_scale
	return PackedVector2Array([
		center + Vector2(0, -half_height),
		center + Vector2(half_width, 0),
		center + Vector2(0, half_height),
		center + Vector2(-half_width, 0),
		center + Vector2(0, -half_height),
	])


func _draw_tile(cell: Vector2i) -> void:
	var center := _project_cell(cell)
	var top := _diamond(center)
	var tile_color := even_tile_color if (cell.x + cell.y) % 2 == 0 else odd_tile_color
	draw_colored_polygon(top, tile_color)
	draw_polyline(_closed_diamond(center), grid_line_color, 1.2, true)

	var grass_x := sin(float(cell.x * 9 + cell.y * 4)) * _tile_width * 0.16
	var grass_origin := center + Vector2(grass_x, _tile_height * 0.12)
	draw_line(grass_origin, grass_origin + Vector2(-2, -5), Color(0.63, 0.82, 0.32, 0.30), 1.0)
	draw_line(grass_origin, grass_origin + Vector2(2, -4), Color(0.63, 0.82, 0.32, 0.24), 1.0)

	if cell in movement_cells:
		draw_colored_polygon(_diamond(center), Color(0.15, 0.89, 0.95, 0.34))
		_draw_tile_badge(center, "M", Color("#c9fbff"))
	if cell in attack_cells:
		draw_colored_polygon(_diamond(center), Color(1.0, 0.24, 0.15, 0.48))
		_draw_tile_badge(center, "A", Color("#ffe0d6"))
	if cell == selected_cell:
		draw_polyline(_closed_diamond(center, 0.88), Color("#ffe28f"), 4.0, true)
	if cell == hover_cell:
		draw_polyline(_closed_diamond(center, 0.92), Color(1, 1, 1, 0.62), 2.0, true)
	if cell == focus_cell and has_focus():
		draw_polyline(_closed_diamond(center, 0.79), Color.WHITE, 2.5, true)

	var font := get_theme_default_font()
	var coordinate := "%s%d" % [String.chr(65 + cell.x), cell.y + 1]
	draw_string(font, center + Vector2(-_tile_width * 0.34, 4), coordinate, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.88, 0.96, 0.83, 0.46))


func _draw_tile_badge(center: Vector2, badge: String, color: Color) -> void:
	var font := get_theme_default_font()
	draw_circle(center, maxf(8.0, _tile_height * 0.24), Color(0.04, 0.14, 0.16, 0.68))
	draw_string(font, center + Vector2(-12, 6), badge, HORIZONTAL_ALIGNMENT_CENTER, 24, 15, color)


func _draw_obstacle(cell: Vector2i) -> void:
	var center := _project_cell(cell) + Vector2(0, -_tile_height * 0.16)
	var width := _tile_width * 0.28
	var height := _tile_height * 1.18
	var top_center := center - Vector2(0, height)
	var left_face := PackedVector2Array([
		top_center + Vector2(-width, 0),
		top_center + Vector2(0, width * 0.28),
		center + Vector2(0, width * 0.28),
		center + Vector2(-width, 0),
	])
	var right_face := PackedVector2Array([
		top_center + Vector2(0, width * 0.28),
		top_center + Vector2(width, 0),
		center + Vector2(width, 0),
		center + Vector2(0, width * 0.28),
	])
	var top_face := PackedVector2Array([
		top_center + Vector2(0, -width * 0.28),
		top_center + Vector2(width, 0),
		top_center + Vector2(0, width * 0.28),
		top_center + Vector2(-width, 0),
	])
	draw_colored_polygon(left_face, Color("#3b4a45"))
	draw_colored_polygon(right_face, Color("#56665c"))
	draw_colored_polygon(top_face, Color("#788778"))
	draw_line(top_center + Vector2(-width * 0.55, -1), center + Vector2(-width * 0.55, 0), Color("#9ca88e"), 2.0)
	draw_circle(top_center + Vector2(width * 0.18, -1), maxf(2.0, width * 0.16), Color("#82a24e"))


func _draw_editor_units() -> void:
	var wolf_definition := HeroCatalogScript.get_definition(HeroCatalogScript.WOLF_GUARDIAN)
	var player_foot := _project_grid(Vector2(1, 3)) + Vector2(0, _tile_height * 0.16)
	var enemy_foot := _project_grid(Vector2(5, 3)) + Vector2(0, _tile_height * 0.18)
	_draw_unit_shadow(player_foot, _tile_width * 0.34, 1.0)
	_draw_unit_texture(wolf_definition.walk_frames[0], player_foot, _tile_width * 1.90, Vector2.ONE, Color.WHITE)
	_draw_unit_health(player_foot + Vector2(0, -_tile_width * 1.90 - 5), 125, 125, Color("#63e4ab"), "Player preview")
	_draw_unit_shadow(enemy_foot, _tile_width * 0.30, 1.0)
	_draw_unit_texture(SLIME_WALK_FRAMES[0], enemy_foot, _tile_width * 1.18, Vector2.ONE, Color.WHITE)
	_draw_unit_health(enemy_foot + Vector2(0, -_tile_width * 1.18 - 4), 55, 55, Color("#ff8a70"), "Moss Slime")


func _draw_player() -> void:
	if player_alpha <= 0.01:
		return
	var idle := sin(_animation_clock * 2.4) * 2.2
	var foot := _project_grid(player_visual_grid) + player_offset + Vector2(0, player_bounce + idle + _tile_height * 0.16)
	_draw_unit_shadow(foot, _tile_width * 0.34, player_alpha)
	var height := _tile_width * (1.72 if combat_state.hero_class_id == "class.fox_mystic" else 1.90)
	var color := Color(1.0, 0.76 + player_flash * 0.24, 0.76 + player_flash * 0.24, player_alpha)
	_draw_unit_texture(_current_player_texture(), foot, height, player_scale, color)
	_draw_unit_health(foot + Vector2(0, -height - 5), combat_state.player_health, combat_state.player_max_health, Color("#63e4ab"), combat_state.player_display_name)


func _draw_enemy() -> void:
	if enemy_alpha <= 0.01 or combat_state.enemy_health <= 0 and enemy_alpha <= 0.05:
		return
	var idle := sin(_animation_clock * 3.2 + 1.2) * 3.0
	var foot := _project_grid(enemy_visual_grid) + enemy_offset + Vector2(0, enemy_bounce + idle + _tile_height * 0.18)
	_draw_unit_shadow(foot, _tile_width * 0.30, enemy_alpha)
	var height := _tile_width * 1.18
	var color := Color(1.0, 1.0 - enemy_flash * 0.44, 1.0 - enemy_flash * 0.44, enemy_alpha)
	_draw_unit_texture(_current_enemy_texture(), foot, height, enemy_scale, color)
	_draw_unit_health(foot + Vector2(0, -height - 4), combat_state.enemy_health, combat_state.ENEMY_MAX_HEALTH, Color("#ff8a70"), "Moss Slime")


func _current_player_texture() -> Texture2D:
	var walk_frames := _player_walk_frames()
	var attack_frames := _player_attack_frames()
	if _player_animation == "attack":
		return attack_frames[clampi(_player_frame, 0, attack_frames.size() - 1)] as Texture2D
	return walk_frames[clampi(_player_frame, 0, walk_frames.size() - 1)] as Texture2D


func _player_walk_frames() -> Array:
	var hero_id: String = combat_state.hero_class_id if combat_state != null else HeroCatalogScript.WOLF_GUARDIAN
	return HeroCatalogScript.get_definition(hero_id).walk_frames


func _player_attack_frames() -> Array:
	var hero_id: String = combat_state.hero_class_id if combat_state != null else HeroCatalogScript.WOLF_GUARDIAN
	return HeroCatalogScript.get_definition(hero_id).attack_frames


func _current_enemy_texture() -> Texture2D:
	if _enemy_animation == "attack":
		return SLIME_ATTACK_FRAMES[clampi(_enemy_frame, 0, SLIME_ATTACK_FRAMES.size() - 1)] as Texture2D
	return SLIME_WALK_FRAMES[clampi(_enemy_frame, 0, SLIME_WALK_FRAMES.size() - 1)] as Texture2D


func _draw_unit_texture(texture: Texture2D, foot: Vector2, height: float, scale_value: Vector2, color: Color) -> void:
	var texture_size := texture.get_size()
	var aspect := texture_size.x / texture_size.y
	var draw_size := Vector2(height * aspect * scale_value.x, height * scale_value.y)
	var rect := Rect2(foot - Vector2(draw_size.x * 0.5, draw_size.y), draw_size)
	draw_texture_rect(texture, rect, false, color)


func _draw_unit_shadow(foot: Vector2, radius: float, alpha: float) -> void:
	var points := PackedVector2Array()
	for index in range(24):
		var angle := TAU * float(index) / 24.0
		points.append(foot + Vector2(cos(angle) * radius, sin(angle) * radius * 0.28))
	draw_colored_polygon(points, Color(0.01, 0.03, 0.03, 0.42 * alpha))


func _draw_unit_health(position: Vector2, health: int, maximum: int, color: Color, unit_name: String) -> void:
	var bar_width := _tile_width * 0.88
	var bar_rect := Rect2(position - Vector2(bar_width * 0.5, 0), Vector2(bar_width, 8))
	draw_rect(bar_rect.grow(2.0), Color(0.02, 0.05, 0.06, 0.88), true)
	var ratio: float = clampf(float(health) / float(maximum), 0.0, 1.0)
	draw_rect(Rect2(bar_rect.position, Vector2(bar_width * ratio, bar_rect.size.y)), color, true)
	var font := get_theme_default_font()
	draw_string(font, position + Vector2(-bar_width * 0.5, -5), unit_name, HORIZONTAL_ALIGNMENT_CENTER, bar_width, 11, Color.WHITE)


func _draw_combat_effects() -> void:
	if enemy_flash > 0.01:
		var center := _project_grid(enemy_visual_grid) + enemy_offset + Vector2(0, -_tile_height * 0.72)
		draw_circle(center, _tile_width * (0.30 + enemy_flash * 0.12), Color(1.0, 0.46, 0.20, enemy_flash * 0.25))
	if player_flash > 0.01:
		var center := _project_grid(player_visual_grid) + player_offset + Vector2(0, -_tile_height * 0.78)
		draw_circle(center, _tile_width * (0.30 + player_flash * 0.12), Color(1.0, 0.40, 0.26, player_flash * 0.25))
	if slash_strength > 0.01:
		var center := _project_grid(enemy_visual_grid) + enemy_offset + Vector2(0, -_tile_height * 0.66)
		var slash_color := Color(0.90, 1.0, 0.80, slash_strength)
		for index in range(3):
			var shift := float(index - 1) * 11.0
			draw_line(center + Vector2(-28, 22 + shift), center + Vector2(24, -24 + shift), slash_color, 5.0)
	if spark_strength > 0.01:
		var start := _project_grid(player_visual_grid) + player_offset + Vector2(0, -_tile_height * 1.10)
		var target := _project_grid(enemy_visual_grid) + enemy_offset + Vector2(0, -_tile_height * 0.72)
		var bolt_position := start.lerp(target, spark_progress)
		var trail_start := start.lerp(target, maxf(0.0, spark_progress - 0.22))
		draw_line(trail_start, bolt_position, Color(0.20, 0.92, 1.0, spark_strength * 0.65), 8.0)
		draw_circle(bolt_position, _tile_width * 0.15, Color(0.18, 0.92, 1.0, spark_strength * 0.24))
		draw_circle(bolt_position, _tile_width * 0.085, Color(0.48, 0.97, 1.0, spark_strength))
		draw_circle(bolt_position, _tile_width * 0.035, Color(1.0, 0.84, 0.32, spark_strength))


func _draw_board_shadow() -> void:
	var center := _board_origin + Vector2(0, _tile_height * 3.15)
	var points := PackedVector2Array()
	for index in range(32):
		var angle := TAU * float(index) / 32.0
		points.append(center + Vector2(cos(angle) * _tile_width * 3.8, sin(angle) * _tile_height * 2.1))
	draw_colored_polygon(points, Color(0.01, 0.04, 0.04, 0.32))


func _draw_ambient_magic() -> void:
	for index in range(12):
		var phase := _animation_clock * (0.55 + float(index % 3) * 0.12) + float(index) * 1.71
		var x := size.x * (0.08 + float((index * 37) % 83) / 100.0)
		var y := size.y * (0.16 + float((index * 53) % 71) / 100.0) + sin(phase) * 14.0
		var alpha := 0.22 + (sin(phase * 1.7) + 1.0) * 0.15
		draw_circle(Vector2(x, y), 2.0 + float(index % 2), Color(0.28, 0.95, 1.0, alpha))
