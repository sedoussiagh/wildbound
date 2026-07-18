@tool
class_name WorldCanvas
extends Control

const HeroCatalogScript = preload("res://scripts/characters/hero_catalog.gd")
const SLIME_WALK_FRAMES := [
	preload("res://assets/characters/moss_slime/walk_0.png"),
	preload("res://assets/characters/moss_slime/walk_1.png"),
	preload("res://assets/characters/moss_slime/walk_2.png"),
	preload("res://assets/characters/moss_slime/walk_3.png"),
]
const OWL_SAGE: Texture2D = preload("res://assets/characters/npcs/owl_sage_v1.png")

const INTERACTION_POSITIONS := {
	"owl_sage": Vector2(165, 260),
	"trade_post": Vector2(398, 180),
	"moon_shrine": Vector2(748, 186),
	"home_plot": Vector2(170, 455),
	"berry_north": Vector2(278, 342),
	"berry_south": Vector2(445, 555),
	"berry_east": Vector2(825, 475),
	"traveler": Vector2(350, 490),
	"moss_slime_woods": Vector2(690, 338),
	"moss_slime_creek": Vector2(535, 245),
	"moss_slime_ruins": Vector2(790, 585),
}

var world_state
var player_position := Vector2(470, 580)
var player_is_walking := false
var player_facing := 1.0
var nearest_interaction := ""
var _clock := 0.0
var _marker_positions: Dictionary = {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cache_marker_positions()
	set_process(true)


func configure(state) -> void:
	world_state = state
	player_position = state.player_position
	queue_redraw()


func get_interaction_position(interaction_id: String) -> Vector2:
	if _marker_positions.has(interaction_id):
		return _marker_positions[interaction_id]
	return INTERACTION_POSITIONS.get(interaction_id, Vector2.ZERO)


func _cache_marker_positions() -> void:
	_marker_positions.clear()
	var marker_root := get_node_or_null("InteractionMarkers")
	if marker_root == null:
		return
	for marker in marker_root.get_children():
		if marker is Marker2D:
			_marker_positions[String(marker.name).to_snake_case()] = marker.position


func _draw_editor_preview() -> void:
	_cache_marker_positions()
	for interaction_id in INTERACTION_POSITIONS:
		var position_value := get_interaction_position(interaction_id)
		draw_circle(position_value, 9.0, Color(1.0, 0.84, 0.35, 0.72))
		draw_string(get_theme_default_font(), position_value + Vector2(13, 5), interaction_id, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("#e6fff5"))
	var preview_position := Vector2(470, 580)
	var preview_definition := HeroCatalogScript.get_definition(HeroCatalogScript.WOLF_GUARDIAN)
	_draw_shadow(preview_position, 28.0)
	_draw_texture_at(preview_definition.walk_frames[0], preview_position, 144.0, Color.WHITE)
	_draw_nameplate(preview_position + Vector2(0, -151), "Player preview", Color("#baffdf"))


func set_player_visual(position_value: Vector2, walking: bool, facing: float) -> void:
	player_position = position_value
	player_is_walking = walking
	if absf(facing) > 0.1:
		player_facing = signf(facing)
	queue_redraw()


func set_nearest_interaction(interaction_id: String) -> void:
	if nearest_interaction == interaction_id:
		return
	nearest_interaction = interaction_id
	queue_redraw()


func _process(delta: float) -> void:
	_clock += delta
	queue_redraw()


func _draw() -> void:
	if world_state == null:
		if Engine.is_editor_hint():
			_draw_editor_preview()
		return
	_draw_world_markers()
	_draw_entities_by_depth()
	_draw_ambient_particles()


func _draw_world_markers() -> void:
	_draw_location_marker(get_interaction_position("home_plot"), "Home Plot", Color("#80e0c0"))
	_draw_location_marker(get_interaction_position("trade_post"), "Trade Post", Color("#ffd27a"))
	_draw_location_marker(get_interaction_position("moon_shrine"), "Moon Shrine", Color("#9edcff"))

	if "Glow Lantern" in world_state.decorations:
		var lantern_position: Vector2 = get_interaction_position("home_plot") + Vector2(0, -22)
		var glow := 14.0 + sin(_clock * 3.0) * 2.5
		draw_circle(lantern_position, glow, Color(1.0, 0.78, 0.28, 0.18))
		draw_circle(lantern_position, 6.0, Color("#ffe29a"))
		draw_line(lantern_position + Vector2(0, 5), lantern_position + Vector2(0, 18), Color("#694a2a"), 4.0)

	for berry_id in ["berry_north", "berry_south", "berry_east"]:
		if berry_id not in world_state.collected_berries:
			_draw_berry(get_interaction_position(berry_id))

	if world_state.quest_stage == "not_started" or world_state.quest_stage == "return":
		_draw_quest_marker(get_interaction_position("owl_sage") + Vector2(0, -108))
	elif world_state.quest_stage == "hunt":
		_draw_quest_marker(get_interaction_position("moss_slime_woods") + Vector2(0, -75))

	if nearest_interaction != "" and get_interaction_position(nearest_interaction) != Vector2.ZERO:
		var pulse := 36.0 + sin(_clock * 5.0) * 4.0
		draw_arc(get_interaction_position(nearest_interaction), pulse, 0, TAU, 40, Color("#fff0a8"), 3.0)


func _draw_entities_by_depth() -> void:
	var entities: Array[Dictionary] = [
		{"kind": "owl", "position": get_interaction_position("owl_sage")},
		{"kind": "traveler", "position": get_interaction_position("traveler")},
		{"kind": "player", "position": player_position},
	]
	entities.append({"kind": "slime", "position": get_interaction_position("moss_slime_woods"), "count": 1})
	entities.append({"kind": "slime", "position": get_interaction_position("moss_slime_creek"), "count": 2})
	entities.append({"kind": "slime", "position": get_interaction_position("moss_slime_ruins"), "count": 3})
	entities.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.position.y < b.position.y)

	for entity in entities:
		match entity.kind:
			"owl":
				_draw_shadow(entity.position, 29.0)
				_draw_texture_at(OWL_SAGE, entity.position, 142.0, Color.WHITE)
				_draw_nameplate(entity.position + Vector2(0, -151), "Owl Sage", Color("#ffe8a8"))
			"traveler":
				var traveler_definition := HeroCatalogScript.get_definition(HeroCatalogScript.WOLF_GUARDIAN)
				_draw_shadow(entity.position, 25.0)
				_draw_texture_at(traveler_definition.walk_frames[0], entity.position, 120.0, Color(0.72, 0.92, 1.0, 0.92))
				_draw_nameplate(entity.position + Vector2(0, -127), "River Scout · Social POC", Color("#8de4ff"))
			"slime":
				_draw_slime_group(entity.position, int(entity.count))
			"player":
				var player_frames := _player_walk_frames()
				var frame := 0
				if player_is_walking:
					frame = int(floor(_clock * 9.0)) % player_frames.size()
				_draw_shadow(entity.position, 28.0)
				var hero_height := 136.0 if world_state.hero_class_id == "class.fox_mystic" else 144.0
				_draw_texture_at(player_frames[frame], entity.position, hero_height, Color.WHITE)
				_draw_nameplate(entity.position + Vector2(0, -151), "%s · You" % world_state.get_hero_display_name(), Color("#baffdf"))


func _player_walk_frames() -> Array:
	var hero_id: String = world_state.hero_class_id if world_state != null else HeroCatalogScript.WOLF_GUARDIAN
	return HeroCatalogScript.get_definition(hero_id).walk_frames


func _draw_slime_group(group_position: Vector2, count: int) -> void:
	var offsets: Array[Vector2] = [Vector2.ZERO]
	if count == 2:
		offsets = [Vector2(-24, 7), Vector2(24, 7)]
	elif count >= 3:
		offsets = [Vector2(0, -12), Vector2(-34, 14), Vector2(34, 14)]
	var slime_frame := int(floor(_clock * 4.0)) % SLIME_WALK_FRAMES.size()
	for index in range(mini(count, offsets.size())):
		var foot := group_position + offsets[index]
		var bob := Vector2(0, sin(_clock * 3.5 + float(index)) * 3.0)
		_draw_shadow(foot, 22.0)
		_draw_texture_at(SLIME_WALK_FRAMES[slime_frame], foot + bob, 86.0, Color.WHITE)
	_draw_nameplate(group_position + Vector2(0, -107), "Moss Slimes ×%d · Encounter" % count, Color("#ffbf9c"))


func _draw_texture_at(texture: Texture2D, foot: Vector2, height: float, tint: Color) -> void:
	var source_size := texture.get_size()
	var width := height * source_size.x / source_size.y
	var rect := Rect2(foot - Vector2(width * 0.5, height), Vector2(width, height))
	draw_texture_rect(texture, rect, false, tint)


func _draw_shadow(foot: Vector2, radius: float) -> void:
	var points := PackedVector2Array()
	for index in range(24):
		var angle := TAU * float(index) / 24.0
		points.append(foot + Vector2(cos(angle) * radius, sin(angle) * radius * 0.28))
	draw_colored_polygon(points, Color(0.01, 0.03, 0.03, 0.42))


func _draw_nameplate(position_value: Vector2, text_value: String, color: Color) -> void:
	var font := get_theme_default_font()
	var font_size := 13
	var width := font.get_string_size(text_value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x + 20.0
	var rect := Rect2(position_value - Vector2(width * 0.5, 15), Vector2(width, 23))
	draw_style_box(_pill_style(Color(0.02, 0.08, 0.09, 0.84), color), rect)
	var text_baseline := rect.position.y + (rect.size.y - font.get_height(font_size)) * 0.5 + font.get_ascent(font_size)
	draw_string(font, Vector2(rect.position.x, text_baseline), text_value, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, color)


func _draw_location_marker(position_value: Vector2, label: String, color: Color) -> void:
	draw_circle(position_value, 25.0 + sin(_clock * 2.0) * 2.0, Color(color, 0.10))
	draw_arc(position_value, 27.0, 0, TAU, 32, Color(color, 0.62), 2.0)
	var font := get_theme_default_font()
	draw_string(font, position_value + Vector2(-55, 44), label, HORIZONTAL_ALIGNMENT_CENTER, 110, 13, color)


func _draw_berry(position_value: Vector2) -> void:
	var bob := sin(_clock * 3.0 + position_value.x) * 2.0
	var center := position_value + Vector2(0, bob - 18)
	draw_circle(center, 18.0, Color(0.35, 0.95, 0.86, 0.12))
	draw_circle(center + Vector2(-7, 2), 6.0, Color("#f05b78"))
	draw_circle(center + Vector2(5, 5), 6.0, Color("#ff7792"))
	draw_circle(center + Vector2(1, -5), 6.0, Color("#e84c71"))
	draw_line(center + Vector2(0, -8), center + Vector2(6, -17), Color("#8ed65b"), 3.0)


func _draw_quest_marker(position_value: Vector2) -> void:
	var center := position_value + Vector2(0, sin(_clock * 4.0) * 4.0)
	draw_circle(center, 15.0, Color("#ffe579"))
	var font := get_theme_default_font()
	draw_string(font, center + Vector2(-8, 7), "!", HORIZONTAL_ALIGNMENT_CENTER, 16, 21, Color("#533b18"))


func _draw_ambient_particles() -> void:
	for index in range(15):
		var phase := _clock * (0.35 + float(index % 4) * 0.08) + float(index) * 1.77
		var x := fmod(float(index * 137), maxf(size.x - 60.0, 1.0)) + 30.0
		var y := fmod(float(index * 83), maxf(size.y - 80.0, 1.0)) + 40.0 + sin(phase) * 12.0
		draw_circle(Vector2(x, y), 1.5 + float(index % 2), Color(0.35, 0.95, 0.94, 0.18 + sin(phase) * 0.08))


func _pill_style(background: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = Color(border, 0.64)
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	return style
