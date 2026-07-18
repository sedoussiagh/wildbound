class_name ArenaDefinition
extends Resource

@export_category("Identity")
@export var arena_id := ""
@export var display_name := ""

@export_category("Layout 9x9")
@export var player_spawn := Vector2i(1, 4)
@export var enemy_spawns: Array[Vector2i] = []
@export var obstacles: Array[Vector2i] = []
