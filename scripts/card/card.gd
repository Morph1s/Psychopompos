extends Area2D

signal card_play_finished

var res = load("res://resources/cards/defend.tres")  # für test-Zwecke mit defend gefüllt
var card_type: CardType
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	print(rng.randi_range(0, 0))
	card_type = res
	$CardImage.texture = card_type.texture 
	

## function to be called on playing the card
## 
## if the card requires targeting an enemy, add its id as the parameter
func play(target_id: int = -1) -> void:
	var actions: Array[Action] = card_type.on_play_action
	for action in actions:
		action.resolve(_get_targets(action.target_type, target_id))
	card_play_finished.emit()

#region local functions

func _get_targets(targeting_mode: Action.TargetType, target_id: int) -> Array[Node2D]:
	var to_return: Array[Node2D] = []
	
	if targeting_mode == Action.TargetType.PLAYER:
		to_return.append(get_tree().get_first_node_in_group("player"))
		
	elif targeting_mode == Action.TargetType.ENEMY_SINGLE and target_id >= 0:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.id == target_id:
				to_return.append(enemy)
				break
		
	elif targeting_mode == Action.TargetType.ENEMY_ALL_INCLUSIVE:
		to_return.append_array(get_tree().get_nodes_in_group("enemy"))
		
	elif targeting_mode == Action.TargetType.ENEMY_ALL_EXCLUSIVE and target_id >= 0:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.id != target_id:
				to_return.append(enemy)
		
	elif targeting_mode == Action.TargetType.ENEMY_ALL_EXCLUSIVE:
		var enemies := get_tree().get_nodes_in_group("enemy")
		to_return.append(enemies[rng.randi_range(0, enemies.size() -1)])
	
	return to_return
	
	#endregion
