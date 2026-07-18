class_name CombatState
extends RefCounted

## Deterministic offline domain model for Increment 1.
## Traces: system.combat@1.0.0, class.wolf_guardian@1.0.0,
## monster.moss_slime@1.0.0.

const GRID_SIZE := 7
const PLAYER_MAX_HEALTH := 125
const PLAYER_POWER := 18
const PLAYER_GUARD := 16
const PLAYER_MAX_AP := 3
const PLAYER_MAX_MP := 3
const ENEMY_MAX_HEALTH := 55
const ENEMY_POWER := 12
const ENEMY_GUARD := 4
const ENEMY_MAX_AP := 3
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

var player_position := Vector2i(1, 3)
var enemy_position := Vector2i(5, 3)
var obstacles: Array[Vector2i] = [Vector2i(3, 2), Vector2i(3, 3)]

var player_health := PLAYER_MAX_HEALTH
var enemy_health := ENEMY_MAX_HEALTH
var player_ap := PLAYER_MAX_AP
var player_mp := PLAYER_MAX_MP
var enemy_ap := ENEMY_MAX_AP
var enemy_mp := ENEMY_MAX_MP
var turn_number := 1
var is_player_turn := true
var is_game_over := false
var outcome := ""


func reset() -> void:
	player_position = Vector2i(1, 3)
	enemy_position = Vector2i(5, 3)
	player_health = PLAYER_MAX_HEALTH
	enemy_health = ENEMY_MAX_HEALTH
	player_ap = PLAYER_MAX_AP
	player_mp = PLAYER_MAX_MP
	enemy_ap = ENEMY_MAX_AP
	enemy_mp = ENEMY_MAX_MP
	turn_number = 1
	is_player_turn = true
	is_game_over = false
	outcome = ""


static func calculate_damage(
	skill_power: int,
	attacker_power: int,
	defender_guard: int,
	scaling: float
) -> int:
	var raw_damage := skill_power + int(floor(float(attacker_power) * scaling))
	var mitigation := 100.0 / (100.0 + float(max(0, defender_guard)))
	return max(1, int(floor(float(raw_damage) * mitigation)))


func manhattan_distance(from_cell: Vector2i, to_cell: Vector2i) -> int:
	return abs(from_cell.x - to_cell.x) + abs(from_cell.y - to_cell.y)


func is_inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < GRID_SIZE and cell.y >= 0 and cell.y < GRID_SIZE


func get_reachable_player_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	if not is_player_turn or is_game_over or player_mp <= 0:
		return cells

	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var cell := Vector2i(x, y)
			if cell == player_position or cell == enemy_position or cell in obstacles:
				continue
			var path := get_player_path(cell)
			if not path.is_empty() and path.size() - 1 <= player_mp:
				cells.append(cell)
	return cells


func get_player_path(target: Vector2i) -> Array[Vector2i]:
	return _find_path(player_position, target, enemy_position)


func try_player_move(target: Vector2i) -> Dictionary:
	if is_game_over:
		return _failure("Le combat est terminé.")
	if not is_player_turn:
		return _failure("Attendez la fin du tour de Moss Slime.")
	if not is_inside(target):
		return _failure("Cette case est hors de la grille.")
	if target == player_position:
		return _failure("Wolf Guardian occupe déjà cette case.")
	if target == enemy_position:
		return _failure("Moss Slime occupe cette case.")
	if target in obstacles:
		return _failure("Un obstacle bloque cette case.")

	var path := get_player_path(target)
	if path.is_empty():
		return _failure("Aucun chemin valide vers cette case.")
	var movement_cost := path.size() - 1
	if movement_cost > player_mp:
		return _failure("Pas assez de MP pour atteindre cette case.")

	var previous_position := player_position
	player_position = target
	player_mp -= movement_cost
	return {
		"ok": true,
		"type": "player_move",
		"from": previous_position,
		"to": player_position,
		"cost": movement_cost,
		"path": path,
	}


func can_use_claw_strike(target: Vector2i = enemy_position) -> bool:
	return (
		is_player_turn
		and not is_game_over
		and player_ap >= 1
		and enemy_health > 0
		and target == enemy_position
		and manhattan_distance(player_position, enemy_position) == 1
	)


func preview_claw_strike_damage() -> int:
	return calculate_damage(CLAW_STRIKE_POWER, PLAYER_POWER, ENEMY_GUARD, CLAW_STRIKE_SCALING)


func player_claw_strike(target: Vector2i) -> Dictionary:
	if is_game_over:
		return _failure("Le combat est terminé.")
	if not is_player_turn:
		return _failure("Ce n'est pas le tour de Wolf Guardian.")
	if player_ap < 1:
		return _failure("Pas assez d'AP pour Claw Strike.")
	if target != enemy_position or enemy_health <= 0:
		return _failure("Claw Strike doit cibler Moss Slime.")
	if manhattan_distance(player_position, enemy_position) != 1:
		return _failure("Moss Slime doit être sur une case adjacente.")

	player_ap -= 1
	var damage := preview_claw_strike_damage()
	enemy_health = max(0, enemy_health - damage)
	if enemy_health == 0:
		is_game_over = true
		outcome = "victory"

	return {
		"ok": true,
		"type": "player_attack",
		"skill": "Claw Strike",
		"damage": damage,
		"enemy_health": enemy_health,
		"victory": outcome == "victory",
	}


func end_player_turn() -> Dictionary:
	if is_game_over:
		return _failure("Le combat est terminé.")
	if not is_player_turn:
		return _failure("Le tour de Wolf Guardian est déjà terminé.")

	is_player_turn = false
	var events := _resolve_enemy_turn()
	return {"ok": true, "type": "turn_resolved", "events": events}


func _resolve_enemy_turn() -> Array[Dictionary]:
	var events: Array[Dictionary] = []
	enemy_ap = ENEMY_MAX_AP
	enemy_mp = ENEMY_MAX_MP

	if manhattan_distance(enemy_position, player_position) > 1:
		var path := _best_enemy_path_to_player()
		if path.size() > 1:
			var movement_cost: int = min(enemy_mp, path.size() - 1)
			var previous_position := enemy_position
			var travelled_path: Array[Vector2i] = []
			for path_index in range(movement_cost + 1):
				travelled_path.append(path[path_index])
			enemy_position = path[movement_cost]
			enemy_mp -= movement_cost
			events.append({
				"type": "enemy_move",
				"from": previous_position,
				"to": enemy_position,
				"cost": movement_cost,
				"path": travelled_path,
			})

	while (
		enemy_ap >= 1
		and player_health > 0
		and manhattan_distance(enemy_position, player_position) == 1
	):
		enemy_ap -= 1
		var damage := calculate_damage(SOFT_BUMP_POWER, ENEMY_POWER, PLAYER_GUARD, SOFT_BUMP_SCALING)
		player_health = max(0, player_health - damage)
		events.append({
			"type": "enemy_attack",
			"skill": "Soft Bump",
			"damage": damage,
			"player_health": player_health,
		})

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


func _best_enemy_path_to_player() -> Array[Vector2i]:
	var best_path: Array[Vector2i] = []
	for target in _neighbors(player_position):
		if target in obstacles:
			continue
		var path := _find_path(enemy_position, target, player_position)
		if path.is_empty():
			continue
		if best_path.is_empty() or path.size() < best_path.size():
			best_path = path
	return best_path


func _find_path(start: Vector2i, target: Vector2i, occupied_cell: Vector2i) -> Array[Vector2i]:
	var empty_path: Array[Vector2i] = []
	if not is_inside(start) or not is_inside(target):
		return empty_path
	if target in obstacles or target == occupied_cell:
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
			if next_cell in obstacles or next_cell == occupied_cell:
				continue
			if came_from.has(next_cell):
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


func _failure(reason: String) -> Dictionary:
	return {"ok": false, "reason": reason}
