class_name CombatState
extends RefCounted

const HeroCatalogScript = preload("res://scripts/characters/hero_catalog.gd")

const GRID_SIZE := 9
const PLAYER_MAX_HEALTH := 125
const PLAYER_POWER := 18
const PLAYER_GUARD := 16
const PLAYER_MAX_AP := 3
const PLAYER_MAX_MP := 3
const ENEMY_MAX_HEALTH := 55
const ENEMY_POWER := 12
const ENEMY_GUARD := 4
const ENEMY_MAX_AP := 1
const ENEMY_MAX_MP := 2
const CLAW_STRIKE_POWER := 20
const CLAW_STRIKE_SCALING := 0.8
const SOFT_BUMP_POWER := 10
const SOFT_BUMP_SCALING := 0.5

const CARDINAL_DIRECTIONS := [
	Vector2i(0, -1),
	Vector2i(-1, 0),
	Vector2i(1, 0),
	Vector2i(0, 1),
]

const ARENAS := [
	preload("res://resources/arenas/moonlit_crossing.tres"),
	preload("res://resources/arenas/moss_ring.tres"),
	preload("res://resources/arenas/broken_path.tres"),
	preload("res://resources/arenas/twin_groves.tres"),
]


class SlimeUnit extends RefCounted:
	var unit_id := ""
	var display_name := "Moss Slime"
	var position := Vector2i.ZERO
	var health := ENEMY_MAX_HEALTH
	var max_health := ENEMY_MAX_HEALTH
	var ap := ENEMY_MAX_AP
	var mp := ENEMY_MAX_MP

	func _init(id_value: String, position_value: Vector2i, index: int) -> void:
		unit_id = id_value
		position = position_value
		display_name = "Moss Slime %d" % (index + 1)

	func is_alive() -> bool:
		return health > 0


var player_position := Vector2i(1, 4)
var obstacles: Array[Vector2i] = []
var enemies: Array[SlimeUnit] = []

var hero_class_id := HeroCatalogScript.WOLF_GUARDIAN
var player_display_name := "Wolf Guardian"
var player_max_health := PLAYER_MAX_HEALTH
var player_power := PLAYER_POWER
var player_guard := PLAYER_GUARD
var player_skills: Array[SkillDefinition] = []

# Compatibility fields used by the first POC tests and other scenes.
var player_basic_skill_name := "Claw Strike"
var player_basic_skill_power := CLAW_STRIKE_POWER
var player_basic_skill_scaling := CLAW_STRIKE_SCALING
var player_basic_skill_range := 1
var player_requires_line_of_sight := false

var player_health := player_max_health
var player_ap := PLAYER_MAX_AP
var player_mp := PLAYER_MAX_MP
var turn_number := 1
var is_player_turn := true
var is_game_over := false
var outcome := ""
var arena_index := 0
var arena_id := "arena.moonlit_crossing"
var arena_name := "Moonlit Crossing"
var encounter_seed := 1
var encounter_group_size := 1

var enemy_position: Vector2i:
	get:
		var enemy := _primary_enemy()
		return enemy.position if enemy != null else Vector2i(-1, -1)
	set(value):
		if not enemies.is_empty():
			enemies[0].position = value

var enemy_health: int:
	get:
		return enemies[0].health if not enemies.is_empty() else 0
	set(value):
		if not enemies.is_empty():
			enemies[0].health = clampi(value, 0, enemies[0].max_health)

var enemy_ap: int:
	get:
		return enemies[0].ap if not enemies.is_empty() else 0
	set(value):
		if not enemies.is_empty():
			enemies[0].ap = value

var enemy_mp: int:
	get:
		return enemies[0].mp if not enemies.is_empty() else 0
	set(value):
		if not enemies.is_empty():
			enemies[0].mp = value


func _init() -> void:
	_configure_hero_values(HeroCatalogScript.WOLF_GUARDIAN)
	setup_encounter(0, 1, 1)


func configure_hero(hero_id: String) -> void:
	_configure_hero_values(hero_id)
	reset()


func _configure_hero_values(hero_id: String) -> void:
	var definition := HeroCatalogScript.get_definition(hero_id)
	hero_class_id = hero_id if HeroCatalogScript.is_valid(hero_id) else HeroCatalogScript.WOLF_GUARDIAN
	player_display_name = definition.display_name
	player_max_health = definition.max_health
	player_power = definition.power
	player_guard = definition.guard
	player_skills.clear()
	for skill in definition.skills:
		player_skills.append(skill)
	if player_skills.is_empty():
		return
	var basic := player_skills[0]
	player_basic_skill_name = basic.display_name
	player_basic_skill_power = basic.power
	player_basic_skill_scaling = basic.scaling
	player_basic_skill_range = basic.cast_range
	player_requires_line_of_sight = basic.requires_line_of_sight


func setup_random_encounter(seed_value: int = 0, group_size_override: int = 0) -> void:
	encounter_seed = seed_value if seed_value != 0 else int(Time.get_ticks_usec())
	var rng := RandomNumberGenerator.new()
	rng.seed = encounter_seed
	var random_group_size := rng.randi_range(1, 3)
	var final_group_size := group_size_override if group_size_override in [1, 2, 3] else random_group_size
	setup_encounter(rng.randi_range(0, ARENAS.size() - 1), final_group_size, encounter_seed)


func setup_encounter(preset_index: int, group_size: int, seed_value: int = 1) -> void:
	arena_index = clampi(preset_index, 0, ARENAS.size() - 1)
	encounter_group_size = clampi(group_size, 1, 3)
	encounter_seed = seed_value
	reset()


func reset() -> void:
	var arena: ArenaDefinition = ARENAS[arena_index]
	arena_id = arena.arena_id
	arena_name = arena.display_name
	player_position = arena.player_spawn
	obstacles.clear()
	for obstacle in arena.obstacles:
		obstacles.append(obstacle)
	enemies.clear()
	for index in range(encounter_group_size):
		var spawn := arena.enemy_spawns[index]
		enemies.append(SlimeUnit.new("slime_%d" % (index + 1), spawn, index))
	player_health = player_max_health
	player_ap = PLAYER_MAX_AP
	player_mp = PLAYER_MAX_MP
	turn_number = 1
	is_player_turn = true
	is_game_over = false
	outcome = ""


static func calculate_damage(skill_power: int, attacker_power: int, defender_guard: int, scaling: float) -> int:
	var raw_damage := skill_power + int(floor(float(attacker_power) * scaling))
	var mitigation := 100.0 / (100.0 + float(max(0, defender_guard)))
	return max(1, int(floor(float(raw_damage) * mitigation)))


func manhattan_distance(from_cell: Vector2i, to_cell: Vector2i) -> int:
	return abs(from_cell.x - to_cell.x) + abs(from_cell.y - to_cell.y)


func is_inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < GRID_SIZE and cell.y >= 0 and cell.y < GRID_SIZE


func get_alive_enemies() -> Array[SlimeUnit]:
	var result: Array[SlimeUnit] = []
	for enemy in enemies:
		if enemy.is_alive():
			result.append(enemy)
	return result


func get_enemy_by_id(enemy_id: String) -> SlimeUnit:
	for enemy in enemies:
		if enemy.unit_id == enemy_id:
			return enemy
	return null


func get_enemy_at(cell: Vector2i, include_defeated: bool = false) -> SlimeUnit:
	for enemy in enemies:
		if enemy.position == cell and (include_defeated or enemy.is_alive()):
			return enemy
	return null


func get_enemy_positions(except_id: String = "") -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for enemy in get_alive_enemies():
		if enemy.unit_id != except_id:
			result.append(enemy.position)
	return result


func get_total_enemy_health() -> int:
	var total := 0
	for enemy in enemies:
		total += enemy.health
	return total


func get_total_enemy_max_health() -> int:
	return enemies.size() * ENEMY_MAX_HEALTH


func get_skill(skill_id: String) -> SkillDefinition:
	for skill in player_skills:
		if skill.skill_id == skill_id:
			return skill
	return player_skills[0] if not player_skills.is_empty() else null


func get_reachable_player_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	if not is_player_turn or is_game_over or player_mp <= 0:
		return cells
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var cell := Vector2i(x, y)
			if cell == player_position or cell in obstacles or get_enemy_at(cell) != null:
				continue
			var path := get_player_path(cell)
			if not path.is_empty() and path.size() - 1 <= player_mp:
				cells.append(cell)
	return cells


func get_skill_range_cells(skill_id: String) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var skill := get_skill(skill_id)
	if skill == null or not is_player_turn or is_game_over or player_ap < skill.ap_cost:
		return cells
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var cell := Vector2i(x, y)
			if cell == player_position or cell in obstacles:
				continue
			if manhattan_distance(player_position, cell) > skill.cast_range:
				continue
			if skill.requires_line_of_sight and not has_line_of_sight(player_position, cell):
				continue
			cells.append(cell)
	return cells


func get_basic_attack_range_cells() -> Array[Vector2i]:
	return get_skill_range_cells(player_skills[0].skill_id)


func get_player_path(target: Vector2i) -> Array[Vector2i]:
	return _find_path(player_position, target, get_enemy_positions())


func try_player_move(target: Vector2i) -> Dictionary:
	if is_game_over:
		return _failure("Le combat est terminé.")
	if not is_player_turn:
		return _failure("Attendez la fin du tour des Slimes.")
	if not is_inside(target):
		return _failure("Cette case est hors de la grille.")
	if target == player_position:
		return _failure("%s occupe déjà cette case." % player_display_name)
	if get_enemy_at(target) != null:
		return _failure("Un Moss Slime occupe cette case.")
	if target in obstacles:
		return _failure("Un obstacle bloque cette case.")
	var path := get_player_path(target)
	if path.is_empty():
		return _failure("Aucun chemin valide vers cette case.")
	var movement_cost := path.size() - 1
	if movement_cost > player_mp:
		return _failure("Pas assez de PM pour atteindre cette case.")
	var previous_position := player_position
	player_position = target
	player_mp -= movement_cost
	return {"ok": true, "type": "player_move", "from": previous_position, "to": player_position, "cost": movement_cost, "path": path}


func can_use_skill(skill_id: String, target: Vector2i) -> bool:
	var skill := get_skill(skill_id)
	var enemy := get_enemy_at(target)
	return (
		skill != null
		and enemy != null
		and is_player_turn
		and not is_game_over
		and player_ap >= skill.ap_cost
		and target in get_skill_range_cells(skill_id)
	)


func preview_skill_damage(skill_id: String) -> int:
	var skill := get_skill(skill_id)
	return skill.preview_damage(player_power, ENEMY_GUARD) if skill != null else 0


func player_use_skill(skill_id: String, target: Vector2i) -> Dictionary:
	var skill := get_skill(skill_id)
	if skill == null:
		return _failure("Sort inconnu.")
	if not can_use_skill(skill_id, target):
		return _failure("La cible est hors de portée, bloquée ou le coût en PA est insuffisant.")
	var primary := get_enemy_at(target)
	var targets: Array[SlimeUnit] = [primary]
	if skill.target_mode == "area":
		targets.clear()
		for enemy in get_alive_enemies():
			if manhattan_distance(target, enemy.position) <= skill.area_radius:
				targets.append(enemy)
				if targets.size() >= skill.max_targets:
					break
	elif skill.target_mode == "chain":
		var candidates := get_alive_enemies()
		candidates.erase(primary)
		candidates.sort_custom(func(a: SlimeUnit, b: SlimeUnit) -> bool: return manhattan_distance(primary.position, a.position) < manhattan_distance(primary.position, b.position))
		for enemy in candidates:
			if targets.size() >= skill.max_targets:
				break
			targets.append(enemy)

	player_ap -= skill.ap_cost
	var damage := preview_skill_damage(skill_id)
	var affected: Array[Dictionary] = []
	for enemy in targets:
		enemy.health = max(0, enemy.health - damage)
		affected.append({"enemy_id": enemy.unit_id, "damage": damage, "health": enemy.health, "defeated": enemy.health == 0})
	if get_alive_enemies().is_empty():
		is_game_over = true
		outcome = "victory"
	return {
		"ok": true,
		"type": "player_skill",
		"skill_id": skill.skill_id,
		"skill": skill.display_name,
		"damage": damage,
		"target_enemy_id": primary.unit_id,
		"affected": affected,
		"victory": outcome == "victory",
	}


func can_use_claw_strike(target: Vector2i = enemy_position) -> bool:
	return can_use_basic_attack(target)


func can_use_basic_attack(target: Vector2i = enemy_position) -> bool:
	return not player_skills.is_empty() and can_use_skill(player_skills[0].skill_id, target)


func preview_claw_strike_damage() -> int:
	return preview_basic_attack_damage()


func preview_basic_attack_damage() -> int:
	return preview_skill_damage(player_skills[0].skill_id)


func player_claw_strike(target: Vector2i) -> Dictionary:
	return player_basic_attack(target)


func player_basic_attack(target: Vector2i) -> Dictionary:
	var result := player_use_skill(player_skills[0].skill_id, target)
	if result.get("ok", false):
		result["enemy_health"] = enemy_health
	return result


func end_player_turn() -> Dictionary:
	if is_game_over:
		return _failure("Le combat est terminé.")
	if not is_player_turn:
		return _failure("Le tour est déjà terminé.")
	is_player_turn = false
	return {"ok": true, "type": "turn_resolved", "events": _resolve_enemy_turn()}


func _resolve_enemy_turn() -> Array[Dictionary]:
	var events: Array[Dictionary] = []
	for enemy in get_alive_enemies():
		enemy.ap = ENEMY_MAX_AP
		enemy.mp = ENEMY_MAX_MP
		if manhattan_distance(enemy.position, player_position) > 1:
			var path := _best_enemy_path_to_player(enemy)
			if path.size() > 1:
				var movement_cost: int = min(enemy.mp, path.size() - 1)
				var previous_position := enemy.position
				var travelled_path: Array[Vector2i] = []
				for path_index in range(movement_cost + 1):
					travelled_path.append(path[path_index])
				enemy.position = path[movement_cost]
				enemy.mp -= movement_cost
				events.append({"type": "enemy_move", "enemy_id": enemy.unit_id, "from": previous_position, "to": enemy.position, "cost": movement_cost, "path": travelled_path})
		if enemy.ap > 0 and player_health > 0 and manhattan_distance(enemy.position, player_position) == 1:
			enemy.ap -= 1
			var damage := calculate_damage(SOFT_BUMP_POWER, ENEMY_POWER, player_guard, SOFT_BUMP_SCALING)
			player_health = max(0, player_health - damage)
			events.append({"type": "enemy_attack", "enemy_id": enemy.unit_id, "skill": "Soft Bump", "damage": damage, "player_health": player_health})
		if player_health == 0:
			break

	if player_health == 0:
		is_game_over = true
		outcome = "defeat"
		events.append({"type": "defeat"})
		return events
	turn_number += 1
	is_player_turn = true
	player_ap = PLAYER_MAX_AP
	player_mp = PLAYER_MAX_MP
	events.append({"type": "player_turn_started", "turn": turn_number})
	return events


func _best_enemy_path_to_player(enemy: SlimeUnit) -> Array[Vector2i]:
	var best_path: Array[Vector2i] = []
	var occupied := get_enemy_positions(enemy.unit_id)
	occupied.append(player_position)
	for target in _neighbors(player_position):
		if target in obstacles or target in occupied:
			continue
		var blocked := get_enemy_positions(enemy.unit_id)
		blocked.append(player_position)
		var path := _find_path(enemy.position, target, blocked)
		if path.is_empty():
			continue
		if best_path.is_empty() or path.size() < best_path.size():
			best_path = path
	return best_path


func has_line_of_sight(from_cell: Vector2i, to_cell: Vector2i) -> bool:
	var delta := to_cell - from_cell
	var steps: int = maxi(abs(delta.x), abs(delta.y))
	if steps <= 1:
		return true
	for index in range(1, steps):
		var progress := float(index) / float(steps)
		var sample := Vector2i(roundi(lerpf(float(from_cell.x), float(to_cell.x), progress)), roundi(lerpf(float(from_cell.y), float(to_cell.y), progress)))
		if sample in obstacles:
			return false
	return true


func _find_path(start: Vector2i, target: Vector2i, occupied_cells: Array[Vector2i]) -> Array[Vector2i]:
	var empty_path: Array[Vector2i] = []
	if not is_inside(start) or not is_inside(target) or target in obstacles or target in occupied_cells:
		return empty_path
	if start == target:
		return [start]
	var frontier: Array[Vector2i] = [start]
	var came_from: Dictionary = {start: start}
	while not frontier.is_empty():
		var current: Vector2i = frontier.pop_front()
		if current == target:
			break
		for next_cell in _neighbors(current):
			if next_cell in obstacles or next_cell in occupied_cells or came_from.has(next_cell):
				continue
			came_from[next_cell] = current
			frontier.append(next_cell)
	if not came_from.has(target):
		return empty_path
	var path: Array[Vector2i] = []
	var cursor := target
	while cursor != start:
		path.push_front(cursor)
		cursor = Vector2i(came_from[cursor])
	path.push_front(start)
	return path


func _neighbors(cell: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for direction in CARDINAL_DIRECTIONS:
		var candidate: Vector2i = cell + direction
		if is_inside(candidate):
			result.append(candidate)
	return result


func _primary_enemy() -> SlimeUnit:
	var alive := get_alive_enemies()
	return alive[0] if not alive.is_empty() else (enemies[0] if not enemies.is_empty() else null)


func _failure(reason: String) -> Dictionary:
	return {"ok": false, "reason": reason}
