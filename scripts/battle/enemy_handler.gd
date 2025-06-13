class_name EnemyHandler
extends Node2D

signal all_enemies_died

const ENEMY = preload("res://scenes/enemy/enemy.tscn")
const ENEMY_WIDTH: int = 82
const ENEMY_PLACEMENT_CENTER_X: int = 320 - 100
const SPEED: float = 0.5
@onready var card_handler: CardHandler = $"../CardHandler"

var enemies_stats: Array[EnemyStats]
var enemies: Array[Enemy]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var rng_zahl: int
var place: Vector2

func initialize() -> void:
	#for testing purpose load preloaded test enemy. This will be changed.
	enemies_stats.append(preload("res://resources/enemies/test_enemy.tres"))
	load_enemy(enemies_stats)

func load_enemy(loading_enemies: Array[EnemyStats]) :
	for enemy in loading_enemies:
		var new_enemy: Enemy = ENEMY.instantiate() as Enemy
		self.add_child(new_enemy)
		new_enemy.stats = enemy
		new_enemy.initialize()
		new_enemy.id = get_child_count()
		new_enemy.mouse_entered_enemy.connect(_on_enemy_enterd)
		new_enemy.mouse_exited_enemy.connect(_on_enemy_exited)
		new_enemy.enemy_died.connect(_an_enmemy_died)
		rng_zahl = rng.randi_range(1,180)
		new_enemy.position = Vector2(340,rng_zahl)
		enemies.append(new_enemy)
	place_enemy_in_scene()



func place_enemy_in_scene():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	for enemy in enemies:
		place = _calculate_enemy_position(enemy.get_index(), enemies.size())
		tween.tween_property(enemy,"position",place,SPEED)

func _calculate_enemy_position(index: int, enemy_count: int) -> Vector2:
	var enemy_distance: int = ENEMY_WIDTH - round(enemy_count / 2) * 2
	var enemy_x_position = ENEMY_PLACEMENT_CENTER_X + index * enemy_distance - enemy_distance * (enemy_count - 1) / 2
	return Vector2(enemy_x_position, 82)

func resolve_intent():
	for enemy in enemies:
		enemy.resolve_intent()
		var timer = get_tree().create_timer(1)
		await timer.timeout

func choose_intent():
	for enemy in enemies:
		enemy.choose_intent()

# removes enemy and checks for win
func _an_enmemy_died(dead_enemy: Enemy):
	enemies.erase(dead_enemy)
	remove_child(dead_enemy)
	if enemies.is_empty():
		all_enemies_died.emit()

#region card played on enemy
## looks if enemy is selecetd with valid card
func _on_enemy_enterd(enemy):
	card_handler.hovered_enemy_id = enemy.id

func _on_enemy_exited(enemy):
	card_handler.hovered_enemy_id = -1
