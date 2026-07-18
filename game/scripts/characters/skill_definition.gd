class_name SkillDefinition
extends Resource

@export_category("Identity")
@export var skill_id := ""
@export var display_name := ""
@export_multiline var description := ""
@export var icon: Texture2D

@export_category("Combat")
@export_range(1, 3, 1) var ap_cost := 1
@export_range(1, 9, 1) var cast_range := 1
@export_range(0, 999, 1) var power := 10
@export_range(0.0, 10.0, 0.05) var scaling := 1.0
@export var requires_line_of_sight := false
@export_enum("single", "area", "chain") var target_mode := "single"
@export_range(0, 4, 1) var area_radius := 0
@export_range(1, 3, 1) var max_targets := 1


func preview_damage(attacker_power: int, defender_guard: int) -> int:
	var raw_damage := power + int(floor(float(attacker_power) * scaling))
	var mitigation := 100.0 / (100.0 + float(max(0, defender_guard)))
	return max(1, int(floor(float(raw_damage) * mitigation)))
