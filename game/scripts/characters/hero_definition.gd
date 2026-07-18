class_name HeroDefinition
extends Resource

@export_category("Identity")
@export var hero_id := ""
@export var display_name := ""
@export var animal := ""
@export_multiline var description := ""
@export var role := ""
@export_enum("Easy", "Medium", "Hard") var difficulty := "Easy"
@export var evolutions: PackedStringArray = []

@export_category("Level 1 Statistics")
@export_range(1, 999, 1) var max_health := 100
@export_range(0, 999, 1) var power := 10
@export_range(0, 999, 1) var guard := 10
@export_range(0, 999, 1) var speed := 10
@export_range(0, 999, 1) var focus := 10
@export_range(0, 999, 1) var resolve := 10

@export_category("Basic Skill")
@export var basic_skill := ""
@export var basic_skill_id := ""
@export_range(0, 999, 1) var basic_skill_power := 10
@export_range(0.0, 10.0, 0.05) var basic_skill_scaling := 1.0
@export_range(1, 20, 1) var basic_skill_range := 1
@export var requires_line_of_sight := false
@export var skill_icon: Texture2D

@export_category("Skills")
@export var skills: Array[SkillDefinition] = []

@export_category("Visuals")
@export var portrait: Texture2D
@export var walk_frames: Array[Texture2D] = []
@export var attack_frames: Array[Texture2D] = []


func to_dictionary() -> Dictionary:
	return {
		"hero_id": hero_id,
		"display_name": display_name,
		"animal": animal,
		"description": description,
		"role": role,
		"difficulty": difficulty,
		"evolutions": Array(evolutions),
		"max_health": max_health,
		"power": power,
		"guard": guard,
		"speed": speed,
		"focus": focus,
		"resolve": resolve,
		"basic_skill": basic_skill,
		"basic_skill_id": basic_skill_id,
		"basic_skill_power": basic_skill_power,
		"basic_skill_scaling": basic_skill_scaling,
		"basic_skill_range": basic_skill_range,
		"requires_line_of_sight": requires_line_of_sight,
		"skill_icon": skill_icon,
		"skills": skills,
		"portrait": portrait,
		"walk_frames": walk_frames,
		"attack_frames": attack_frames,
	}
