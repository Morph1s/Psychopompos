class_name Card
extends Area2D

enum HighlightMode {NONE, HOVERED, SELECTED}

signal mouse_entered_card(Node)
signal mouse_exited_card(Node)
signal card_play_finished

const MAIN_THEME = preload("res://resources/theme/main_theme.tres")

@onready var card_image = $CardImage
@onready var card_highlight: Sprite2D = $CardHighlight
@onready var energy_cost = $EnergyCost
@onready var card_name = $Name
@onready var card_shape = $CardShape
@onready var description = $Description

var card_mode: HighlightMode = HighlightMode.NONE # for card-selecting/-hovering
var card_type: CardType
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var mouse_is_in_card: bool = false
var index: int = 0:
	set(value):
		z_index = value
		index = value


func initialize(card_type: CardType) -> void:
	if not is_node_ready():
		await ready
	
	self.card_type = card_type
	card_image.texture = card_type.texture
	energy_cost.text = str(card_type.energy_cost)
	card_type.energy_cost_changed.connect(_on_card_type_energy_cost_changed)
	card_name.text = card_type.card_name
	
	_set_description(card_type.first_description_icon, card_type.first_description_text,0)
	_set_description(card_type.second_description_icon, card_type.second_description_text, 1)

## function for CardHandler to handle card-state
## CardHandler passes the enum HighlightMode as mode 
func highlight(mode: HighlightMode):
	if mode == HighlightMode.HOVERED:
		if card_mode == HighlightMode.SELECTED:
			_update_image_y_positions(5)
		card_highlight.show()
		self.z_index = 10
		card_mode = HighlightMode.HOVERED
	elif mode == HighlightMode.SELECTED:
		card_mode = HighlightMode.SELECTED
		self.z_index = 11
		_update_image_y_positions(-5)
		card_highlight.show()
	else:
		if card_mode == HighlightMode.SELECTED: 
			_update_image_y_positions(5)
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
	#get_tree().get_first_node_in_group("player").stats.current_energy
	
	var actions: Array[Action] = card_type.on_play_action
	for action in actions:
		action.resolve(_get_targets(action.target_type, target_id))
	
	# call the player played attack event if the card contains an attack
	for action in actions:
		if action is AttackAction:
			EventBusHandler.player_played_attack.emit()
	
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

func _update_image_y_positions(value: int) -> void:
	position.y += value
	card_shape.position.y -= value

func _set_description(icon: Texture, text: String, index: int) -> void:
	if 2 < index:
		push_error("too many descriptions for card: ", card_type.card_name)
		return
	
	if icon:
		var sprite = Sprite2D.new()
		sprite.centered = false
		sprite.texture = icon
		sprite.position = Vector2(0, 9 * index)
		description.add_child(sprite)
	
	if text:
		var label = Label.new()
		label.theme = MAIN_THEME
		label.text = text
		label.position = Vector2(9, (9 * index) + 2)
		description.add_child(label)

#endregion

#region signal functions

func _on_mouse_entered() -> void:
	mouse_is_in_card= true
	mouse_entered_card.emit(self)

func _on_mouse_exited() -> void:
	mouse_is_in_card = false
	mouse_exited_card.emit(self)

func _on_card_type_energy_cost_changed(new_value: int) -> void:
	energy_cost.text = str(new_value)

#endregion
