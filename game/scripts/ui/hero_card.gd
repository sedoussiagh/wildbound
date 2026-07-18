@tool
class_name HeroCard
extends PanelContainer

signal hero_requested(hero_id: String)

@export var hero_definition: HeroDefinition:
	set(value):
		hero_definition = value
		if is_node_ready():
			_refresh_from_definition()
@export var accent_color := Color("#72d4b2"):
	set(value):
		accent_color = value
		if is_node_ready():
			_refresh_from_definition()
@export var normal_style: StyleBoxFlat
@export var selected_style: StyleBoxFlat

@onready var portrait: TextureRect = %Portrait
@onready var name_label: Label = %NameLabel
@onready var role_label: Label = %RoleLabel
@onready var stats_label: Label = %StatsLabel
@onready var description_label: Label = %DescriptionLabel
@onready var choose_button: Button = %ChooseButton


func _ready() -> void:
	choose_button.pressed.connect(_on_choose_pressed)
	_refresh_from_definition()
	set_selected(false)


func set_selected(selected: bool) -> void:
	if selected and selected_style != null:
		add_theme_stylebox_override("panel", selected_style)
	elif normal_style != null:
		add_theme_stylebox_override("panel", normal_style)


func _refresh_from_definition() -> void:
	if hero_definition == null or not is_node_ready():
		return
	portrait.texture = hero_definition.portrait
	name_label.text = hero_definition.display_name
	name_label.add_theme_color_override("font_color", accent_color)
	role_label.text = "%s · Difficulty: %s" % [hero_definition.role, hero_definition.difficulty]
	stats_label.text = "HP %d  ·  Power %d  ·  Guard %d  ·  Speed %d\n%s · Range %d\nEvolutions: %s" % [
		hero_definition.max_health,
		hero_definition.power,
		hero_definition.guard,
		hero_definition.speed,
		hero_definition.basic_skill,
		hero_definition.basic_skill_range,
		" / ".join(hero_definition.evolutions),
	]
	description_label.text = hero_definition.description
	choose_button.text = "Choisir %s" % hero_definition.display_name


func _on_choose_pressed() -> void:
	if hero_definition != null:
		hero_requested.emit(hero_definition.hero_id)
