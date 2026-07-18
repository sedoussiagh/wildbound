class_name CharacterSelect
extends Control

signal character_confirmed(hero_id: String)
signal cancel_requested

const HeroCatalogScript = preload("res://scripts/characters/hero_catalog.gd")

@export var default_hero_id := HeroCatalogScript.WOLF_GUARDIAN

@onready var wolf_card: HeroCard = %WolfGuardianCard
@onready var fox_card: HeroCard = %FoxMysticCard
@onready var confirm_button: Button = %ConfirmButton
@onready var cancel_button: Button = %CancelButton
@onready var selection_label: Label = %SelectionLabel
@onready var title_label: Label = %Title
@onready var subtitle_label: Label = %Subtitle

var selected_hero_id := ""
var hero_cards: Dictionary = {}
var allow_cancel := false


func configure(initial_hero_id: String = "", can_cancel: bool = false) -> void:
	if HeroCatalogScript.is_valid(initial_hero_id):
		default_hero_id = initial_hero_id
	allow_cancel = can_cancel


func _ready() -> void:
	hero_cards = {
		HeroCatalogScript.WOLF_GUARDIAN: wolf_card,
		HeroCatalogScript.FOX_MYSTIC: fox_card,
	}
	for card in hero_cards.values():
		(card as HeroCard).hero_requested.connect(select_hero)
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	cancel_button.visible = allow_cancel
	if allow_cancel:
		title_label.text = "CHANGEZ VOTRE CLASSE"
		subtitle_label.text = "Votre progression est conservée. Choisissez librement votre style de combat."
	select_hero(default_hero_id)


func select_hero(hero_id: String) -> void:
	if not HeroCatalogScript.is_valid(hero_id):
		return
	selected_hero_id = hero_id
	for card_id in hero_cards:
		(hero_cards[card_id] as HeroCard).set_selected(card_id == selected_hero_id)
	var hero := HeroCatalogScript.get_hero(selected_hero_id)
	selection_label.text = "%s sélectionné · La classe peut être changée depuis le monde ouvert." % hero.display_name
	confirm_button.text = ("Choisir %s" if allow_cancel else "Commencer avec %s") % hero.display_name


func _on_confirm_pressed() -> void:
	character_confirmed.emit(selected_hero_id)


func _on_cancel_pressed() -> void:
	cancel_requested.emit()
