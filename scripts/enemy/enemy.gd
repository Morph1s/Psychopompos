class_name Enemy
extends Area2D

signal action_resolved

@export var stats: EnemyStats

@onready var image: Sprite2D = $EnemyImage
@onready var shape: CollisionShape2D = $EnemyShape

var id: int = 0
var intent: int = -1 #Damit in Runde eins der intent auf null erhöht werden kann
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func initialize() -> void:
	stats.initialize()
	image.texture = stats.enemy_sprite
	shape.shape.size = image.texture.get_size()

func take_damage(damage_amount:int) -> void:
	stats.take_damage(damage_amount)

func lose_hp(hp_loss:int) -> void:
	stats.lose_hp(hp_loss)

func gain_block(gain_block:int) -> void:
	stats.block += gain_block

func resolve_intent() -> void:
	var actions: Array[Action] = stats.actions[intent].action_catalogue
	for action in actions:
		action.resolve(_get_targets(action.target_type))
	action_resolved.emit()

func choose_intent(turn: int) -> void:
	if stats.action_pattern == stats.ActionPattern.LINEAR :
		intent += 1
		if intent >= stats.actions.size():
			intent = 0
	else: 
		intent = rng.randi_range(0,stats.actions.size())
	
	

#region local functions

func _get_targets(targeting_mode: Action.TargetType) -> Array[Node2D]:
	var to_return: Array[Node2D] = []
	
	if targeting_mode == Action.TargetType.PLAYER:
		to_return.append(get_tree().get_first_node_in_group("player"))
		
	elif targeting_mode == Action.TargetType.ENEMY_SINGLE:
		to_return.append(self)
		
	elif targeting_mode == Action.TargetType.ENEMY_ALL_INCLUSIVE:
		to_return.append_array(get_tree().get_nodes_in_group("enemy"))
		
	elif targeting_mode == Action.TargetType.ENEMY_ALL_EXCLUSIVE:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.id != id:
				to_return.append(enemy)
		
	elif targeting_mode == Action.TargetType.ENEMY_RANDOM:
		var enemies := get_tree().get_nodes_in_group("enemy")
		to_return.append(enemies[rng.randi_range(0, enemies.size() -1)])
	
	return to_return

#endregion
