class_name EnemyHandler
extends Node2D

signal all_enemies_died

const ENEMY = preload("res://scenes/enemy/enemy.tscn")
const ENEMY_MINIMUM_DISTANCE: int = 68
const ENEMY_PLACEMENT_CENTER_X: int = 220
@onready var card_handler: CardHandler = $"../CardHandler"

var enemies_stats: Array[EnemyStats]
var enemies: Array[Enemy]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var random_y_position: int

func initialize(enemies_data: Array[EnemyStats]) -> void:
	enemies_stats = enemies_data
	load_enemies(enemies_stats)

func load_enemies(loading_enemies: Array[EnemyStats]) :
	var index: int = 0
	for enemy: EnemyStats in loading_enemies:
		var new_enemy: Enemy = ENEMY.instantiate() as Enemy
		self.add_child(new_enemy)
		new_enemy.stats = enemy.duplicate()
		new_enemy.initialize()
		new_enemy.id = get_child_count()
		new_enemy.mouse_entered_enemy.connect(_on_enemy_enterd)
		new_enemy.mouse_exited_enemy.connect(_on_enemy_exited)
		new_enemy.enemy_died.connect(_an_enemy_died)
		new_enemy.position = Vector2(_calculate_enemy_x_position(index, loading_enemies.size()), new_enemy.y_position)
		enemies.append(new_enemy)
		index += 1

func _calculate_enemy_x_position(index: int, enemy_count: int) -> int:
	var enemies_total_width: int = ENEMY_MINIMUM_DISTANCE * enemy_count
	var enemy_x_position: int = (ENEMY_PLACEMENT_CENTER_X - enemies_total_width / 2) + ENEMY_MINIMUM_DISTANCE * index
	return enemy_x_position

func resolve_intent():
	for enemy in enemies:
		if enemy.is_dead:
			await get_tree().create_timer(0.3).timeout
			continue
		await enemy.resolve_intent()
		await get_tree().create_timer(0.8).timeout

func choose_intent():
	for enemy in enemies:
		enemy.choose_intent()

func display_enemy_highlights(visibility: bool) -> void:
	if visibility:
		for enemy: Enemy in get_children():
			enemy.show_highlights()
	else:
		for enemy: Enemy in get_children():
			enemy.hide_highlights()

func start_of_enemy_turn() -> void:
	for enemy in get_children():
		await enemy.start_of_turn()

func end_of_enemy_turn() -> void:
	for enemy in get_children():
		await enemy.end_of_turn()

# removes enemy and checks for win
func _an_enemy_died(dead_enemy: Enemy):
	card_handler.hovered_enemy_id = -1
	enemies.erase(dead_enemy)
	remove_child(dead_enemy)
	dead_enemy.queue_free()
	if enemies.is_empty():
		all_enemies_died.emit()

#region card played on enemy
## looks if enemy is selecetd with valid card
func _on_enemy_enterd(enemy):
	card_handler.hovered_enemy_id = enemy.id

func _on_enemy_exited(_enemy):
	card_handler.hovered_enemy_id = -1
