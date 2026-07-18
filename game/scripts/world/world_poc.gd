class_name WorldPoc
extends Control

signal combat_requested(encounter_id: String)
signal class_change_requested
signal state_changed

const WorldStateScript = preload("res://scripts/world/world_state.gd")

const MOVE_SPEED := 185.0
const INTERACTION_DISTANCE := 92.0

var world_state
@onready var world_canvas: WorldCanvas = %WorldCanvas
@onready var background: TextureRect = %WorldBackground
@onready var side_panel: PanelContainer = %ExplorationHUD
@onready var stats_label: Label = %StatsLabel
@onready var objective_label: Label = %ObjectiveLabel
@onready var inventory_label: Label = %InventoryLabel
@onready var status_label: Label = %StatusLabel
@onready var interaction_button: Button = %InteractionButton
@onready var change_class_button: Button = %ChangeClassButton
@onready var chat_label: RichTextLabel = %ChatLabel
@onready var move_hint: Label = %MoveHint
@onready var dpad: Control = %MobileDPad

var _destination := Vector2.ZERO
var _has_destination := false
var _pending_interaction := ""
var _mobile_direction := Vector2.ZERO
var _nearest_interaction := ""
var _chat_history: Array[String] = []
var _resume_message := ""


func configure(state, resume_message: String = "") -> void:
	world_state = state
	_resume_message = resume_message


func _ready() -> void:
	if world_state == null:
		world_state = WorldStateScript.new()
	world_canvas.configure(world_state)
	interaction_button.pressed.connect(_on_interaction_pressed)
	change_class_button.pressed.connect(_on_change_class_pressed)
	for child in dpad.get_children():
		if child is Button and child.has_meta("direction"):
			var direction: Vector2 = child.get_meta("direction")
			child.button_down.connect(_on_dpad_pressed.bind(direction))
			child.button_up.connect(_on_dpad_released.bind(direction))
	_append_chat("Bienvenue dans Whispering Woods.")
	if _resume_message != "":
		_append_chat(_resume_message)
		status_label.text = _resume_message
	_refresh_interface()
	set_process(true)


func _process(delta: float) -> void:
	if world_canvas == null:
		return
	var keyboard_direction := Vector2(
		float(Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) - float(Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)),
		float(Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)) - float(Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP))
	)
	var direction := _mobile_direction if _mobile_direction.length_squared() > 0.0 else keyboard_direction
	var walking := false
	if direction.length_squared() > 0.0:
		_has_destination = false
		_pending_interaction = ""
		direction = direction.normalized()
		world_state.player_position += direction * MOVE_SPEED * delta
		walking = true
	elif _has_destination:
		var distance: float = world_state.player_position.distance_to(_destination)
		if distance <= 4.0:
			world_state.player_position = _destination
			_has_destination = false
		else:
			var step := minf(MOVE_SPEED * delta, distance)
			direction = world_state.player_position.direction_to(_destination)
			world_state.player_position += direction * step
			walking = true

	var max_x := minf(world_canvas.size.x - 48.0, 885.0)
	world_state.player_position.x = clampf(world_state.player_position.x, 55.0, max_x)
	world_state.player_position.y = clampf(world_state.player_position.y, 112.0, size.y - 55.0)
	world_canvas.set_player_visual(world_state.player_position, walking, direction.x)
	_update_nearest_interaction()

	if not _has_destination and _pending_interaction != "":
		var interaction_id := _pending_interaction
		_pending_interaction = ""
		if world_state.player_position.distance_to(_interaction_position(interaction_id)) <= INTERACTION_DISTANCE + 8.0:
			_interact(interaction_id)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		_on_interaction_pressed()
		get_viewport().set_input_as_handled()
		return
	var tap_position := Vector2(-1, -1)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		tap_position = event.position
	elif event is InputEventScreenTouch and event.pressed:
		tap_position = event.position
	if tap_position.x < 0.0 or tap_position.x > world_canvas.size.x:
		return
	_handle_world_tap(tap_position)
	get_viewport().set_input_as_handled()


func _handle_world_tap(tap_position: Vector2) -> void:
	var tapped_interaction := ""
	var best_distance := INF
	for interaction_id in _active_interactions():
		var distance := tap_position.distance_to(_interaction_position(interaction_id))
		var hit_radius := 92.0 if interaction_id.begins_with("moss_slime_") else 62.0
		if distance <= hit_radius and distance < best_distance:
			best_distance = distance
			tapped_interaction = interaction_id
	if tapped_interaction != "":
		if world_state.player_position.distance_to(_interaction_position(tapped_interaction)) <= INTERACTION_DISTANCE:
			_interact(tapped_interaction)
		else:
			_destination = _interaction_position(tapped_interaction) + Vector2(0, 52)
			_has_destination = true
			_pending_interaction = tapped_interaction
			status_label.text = "%s rejoint %s…" % [world_state.get_hero_display_name(), _interaction_label(tapped_interaction)]
		return
	_destination = Vector2(
		clampf(tap_position.x, 55.0, minf(world_canvas.size.x - 48.0, 885.0)),
		clampf(tap_position.y, 112.0, size.y - 55.0)
	)
	_has_destination = true
	_pending_interaction = ""


func _update_nearest_interaction() -> void:
	var nearest := ""
	var nearest_distance := INTERACTION_DISTANCE
	for interaction_id in _active_interactions():
		var distance: float = world_state.player_position.distance_to(_interaction_position(interaction_id))
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = interaction_id
	if nearest == _nearest_interaction:
		return
	_nearest_interaction = nearest
	world_canvas.set_nearest_interaction(nearest)
	_refresh_interaction_button()


func _active_interactions() -> Array[String]:
	var result: Array[String] = ["owl_sage", "trade_post", "moon_shrine", "home_plot", "traveler"]
	for berry_id in ["berry_north", "berry_south", "berry_east"]:
		if berry_id not in world_state.collected_berries:
			result.append(berry_id)
	result.append("moss_slime_woods")
	result.append("moss_slime_creek")
	result.append("moss_slime_ruins")
	return result


func _on_interaction_pressed() -> void:
	if _nearest_interaction == "":
		status_label.text = "Approchez-vous d'un personnage ou d'un point d'intérêt."
		return
	_interact(_nearest_interaction)


func _interact(interaction_id: String) -> void:
	var result: Dictionary
	match interaction_id:
		"owl_sage":
			result = world_state.interact_with_sage()
		"trade_post":
			result = world_state.trade_at_post()
		"moon_shrine":
			result = world_state.rest_at_shrine()
		"home_plot":
			result = world_state.place_home_decoration()
		"berry_north", "berry_south", "berry_east":
			result = world_state.collect_berry(interaction_id)
		"traveler":
			result = {"ok": true, "title": "River Scout", "message": "Hello! Cette présence sociale est locale dans le POC ; le vrai réseau viendra avec le serveur."}
		"moss_slime_woods", "moss_slime_creek", "moss_slime_ruins":
			status_label.text = "%s vous défie. Préparation du combat…" % _interaction_label(interaction_id)
			state_changed.emit()
			combat_requested.emit(interaction_id)
			return
		_:
			result = {"ok": false, "title": "Inconnu", "message": "Aucune interaction disponible."}
	_show_result(result)
	state_changed.emit()
	_refresh_interface()
	world_canvas.queue_redraw()


func _show_result(result: Dictionary) -> void:
	var message: String = str(result.get("message", ""))
	status_label.text = "%s · %s" % [str(result.get("title", "Action")), message]
	_append_chat(message)


func _refresh_interface() -> void:
	stats_label.text = "%s · Level %d\nXP %d/100 · Energy %d/5" % [world_state.get_hero_display_name(), world_state.get_level(), world_state.experience % 100, world_state.energy]
	objective_label.text = world_state.get_objective_text()
	inventory_label.text = "🎒 Glow Berry ×%d\n🍃 Leaf Coins ×%d · Decorations ×%d" % [world_state.glow_berries, world_state.leaf_coins, world_state.decorations.size()]
	_refresh_interaction_button()


func _refresh_interaction_button() -> void:
	if interaction_button == null:
		return
	if _nearest_interaction == "":
		interaction_button.text = "Aucune interaction proche"
		interaction_button.disabled = true
	else:
		interaction_button.text = "Interagir · %s" % _interaction_label(_nearest_interaction)
		interaction_button.disabled = false


func _on_change_class_pressed() -> void:
	state_changed.emit()
	class_change_requested.emit()


func _append_chat(message: String) -> void:
	_chat_history.append(message)
	if _chat_history.size() > 5:
		_chat_history.pop_front()
	if chat_label != null:
		chat_label.text = "\n".join(_chat_history)


func _interaction_position(interaction_id: String) -> Vector2:
	return world_canvas.get_interaction_position(interaction_id)


func _on_dpad_pressed(direction: Vector2) -> void:
	_mobile_direction = direction


func _on_dpad_released(direction: Vector2) -> void:
	if _mobile_direction == direction:
		_mobile_direction = Vector2.ZERO


func _interaction_label(interaction_id: String) -> String:
	match interaction_id:
		"owl_sage": return "Owl Sage"
		"trade_post": return "Trade Post"
		"moon_shrine": return "Moon Shrine"
		"home_plot": return "Home Plot"
		"berry_north", "berry_south", "berry_east": return "Glow Berry"
		"traveler": return "River Scout"
		"moss_slime_woods": return "Moss Slime"
		"moss_slime_creek": return "Moss Slimes ×2"
		"moss_slime_ruins": return "Moss Slimes ×3"
	return "Point d'intérêt"
