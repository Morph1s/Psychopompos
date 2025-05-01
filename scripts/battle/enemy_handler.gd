extends Node2D

var ENEMY = preload("res://scenes/enemy/enemy.tscn")
var ENEMY_WIDTH: int = 40
var ENEMY_PLACEMENT_CENTER_X: int = 430
var SPEED: float = 0.5

var enemies_stats: Array[EnemyStats]
var enemies: Array[Enemy]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var rng_zahl: int
var place: Vector2

func load_enemy(loading_enemies: Array[EnemyStats]) :
	for e in loading_enemies:
		var new_enemy: Enemy = ENEMY.instantiate() as Enemy
		self.add_child(new_enemy)
		new_enemy.stats = e
		new_enemy.initialize()
		rng_zahl = rng.randi_range(1,400)
		new_enemy.position = Vector2(670,rng_zahl) # platziert zuffälig rechts ausser sichtweite
		enemies.append(new_enemy)
	place_enemy_in_scene()

func place_enemy_in_scene():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	for e in enemies:
		place = _calculate_enemie_position(e.get_index(), enemies.size())
		tween.tween_property(e,"position",place,SPEED)

func _calculate_enemie_position(index: int, enemie_count: int) -> Vector2:
	var enemy_distance: int = ENEMY_WIDTH - round(enemie_count / 2) * 2
	var enemy_x_position = ENEMY_PLACEMENT_CENTER_X + index * enemy_distance - enemy_distance * (enemie_count - 1) / 2
	return Vector2(enemy_x_position, 240)

func resolve_intent():
	for enemy in enemies:
		var timer = get_tree().create_timer(1)
		await timer.timeout
		enemy.resolve_intent()
		
func choose_intent():
	for e in enemies:
		e.choose_intent()



func _ready() -> void:
	enemies_stats.append(preload("res://resources/enemies/test_enemy.tres"))
	load_enemy(enemies_stats)
