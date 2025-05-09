extends Node2D

var ENEMY = preload("res://scenes/enemy/enemy.tscn")
var ENEMY_WIDTH: int = 64
var ENEMY_PLACEMENT_CENTER_X: int = 320 - 100
var SPEED: float = 0.5

var enemies_stats: Array[EnemyStats]
var enemies: Array[Enemy]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var rng_zahl: int
var place: Vector2

func load_enemy(loading_enemies: Array[EnemyStats]) :
	for enemy in loading_enemies:
		var new_enemy: Enemy = ENEMY.instantiate() as Enemy
		self.add_child(new_enemy)
		new_enemy.stats = enemy
		new_enemy.initialize()
		rng_zahl = rng.randi_range(1,180)
		new_enemy.position = Vector2(340,rng_zahl) # platziert zuffälig rechts ausser sichtweite
		enemies.append(new_enemy)
	place_enemy_in_scene()

func place_enemy_in_scene():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	for enemy in enemies:
		place = _calculate_enemie_position(enemy.get_index(), enemies.size())
		tween.tween_property(enemy,"position",place,SPEED)

func _calculate_enemie_position(index: int, enemie_count: int) -> Vector2:
	var enemy_distance: int = ENEMY_WIDTH - round(enemie_count / 2) * 2
	var enemy_x_position = ENEMY_PLACEMENT_CENTER_X + index * enemy_distance - enemy_distance * (enemie_count - 1) / 2
	return Vector2(enemy_x_position, 82)

func resolve_intent():
	for enemy in enemies:
		enemy.resolve_intent()
		var timer = get_tree().create_timer(1)
		await timer.timeout

func choose_intent():
	for enemy in enemies:
		enemy.choose_intent()



func _ready() -> void:
	enemies_stats.append(preload("res://resources/enemies/test_enemy.tres"))
	load_enemy(enemies_stats)
