class_name Card
extends Area2D

enum HighlightMode {NONE, HOVERED, SELECTED}

signal mouse_entered_card(Node)
signal mouse_exited_card(Node)
signal card_play_finished

@onready var card_image: Sprite2D = $CardImage
@onready var card_highlight: Sprite2D = $CardHighlight

var card_mode: HighlightMode = HighlightMode.NONE # for card-selecting/-hovering
var card_type: CardType
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var mouse_is_in_card: bool = false
var index: int = 0:
	set(value):
		z_index = value
		index = value
 
func initialize(card_type: CardType) -> void:
	self.card_type = card_type
	$CardImage.texture = card_type.texture

## function for CardHandler to handle card-state
## CardHandler passes the enum HighlightMode as mode 
func highlight(mode: HighlightMode):
	if mode == HighlightMode.HOVERED:
		if card_mode == HighlightMode.SELECTED: 
			self.card_image.position.y += 5
			self.card_highlight.position.y += 5
		card_highlight.show()
		self.z_index = 10
		card_mode = HighlightMode.HOVERED
	elif mode == HighlightMode.SELECTED:
		card_mode = HighlightMode.SELECTED
		self.z_index = 11
		self.card_image.position.y -= 5
		self.card_highlight.position.y -= 5
		card_highlight.show()
	else:
		if card_mode == HighlightMode.SELECTED: 
			self.card_image.position.y += 5
			self.card_highlight.position.y += 5
		card_highlight.hide()
		self.z_index = index
		card_mode = HighlightMode.NONE

## call after adding node to tree to setup the modifiers
func set_modifier_handler() -> void:
	card_type.set_modifier_handler(get_tree().get_first_node_in_group("player").modifier_handler)

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
		
	elif targeting_mode == Action.TargetType.ENEMY_RANDOM:
		var enemies := get_tree().get_nodes_in_group("enemy")
		to_return.append(enemies[rng.randi_range(0, enemies.size() -1)])
	
	return to_return
	
#endregion

func _on_mouse_entered() -> void:
	mouse_is_in_card= true
	mouse_entered_card.emit(self)

func _on_mouse_exited() -> void:
	mouse_is_in_card = false
	mouse_exited_card.emit(self)
