class_name Card
extends Area2D

enum HighlightMode {
	NONE,
	HOVERED,
	SELECTED,
	PLAYED,
	}

signal mouse_entered_card(Node)
signal mouse_exited_card(Node)

const MAIN_THEME = preload("res://resources/theme/main_theme.tres")
const CARD_ENERGY_BALL = preload("res://assets/graphics/cards/card_energy_ball.png")

const NORMAL_HEIGHT: int = 150
const SELECTED_HEIGHT: int = 146
const PLAYED_HEIGHT: int = 142

@onready var card_image: Sprite2D = $CardImage
@onready var card_highlight: AnimatedSprite2D = $CardHighlight
@onready var energy_ball_container = $EnergyBallContainer
@onready var card_name: Label = $Name
@onready var card_shape: CollisionShape2D = $CardShape
@onready var description: Node2D = $Description
@onready var action_timer: Timer = $ActionTimer

## all data about the kind of card this is and its visuals and effects
var card_type: CardType

# manages whether a card can be hovered and selected
var playable = false:
	set(value):
		input_pickable = value
		playable = value

## index of card in hand
var index: int = 0:
	set(value):
		z_index = value
		index = value

var card_mode: HighlightMode = HighlightMode.NONE # for card-selecting/-hovering
var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func initialize(card: CardType) -> void:
	if not is_node_ready():
		await ready
	
	# setup card type
	card_type = card
	card_type.set_modifier_handler(get_tree().get_first_node_in_group("player").modifier_handler)
	
	# load card visuals
	
	card_image.texture = card_type.texture
	_create_energy_cost_balls(card_type.energy_cost)
	card_type.energy_cost_changed.connect(_on_card_type_energy_cost_changed)
	card_name.text = card_type.card_name
	_set_description(card_type.first_description_icon, card_type.first_description_text,0)
	_set_description(card_type.second_description_icon, card_type.second_description_text, 1)
	
	# set visuals based on rarity
	match card_type.rarity:
		CardType.Rarity.STARTING_CARD:
			card_name.add_theme_color_override("font_color", Color.WHITE)
		CardType.Rarity.COMMON_CARD:
			card_name.add_theme_color_override("font_color", Color.WHITE)
		CardType.Rarity.HERO_CARD:
			card_name.add_theme_color_override("font_color", Color.PURPLE)
		CardType.Rarity.GODS_BOON:
			card_name.add_theme_color_override("font_color", Color.GOLD)


## function for CardHandler to handle card-state
func highlight(mode: HighlightMode):
	match mode:
		HighlightMode.NONE:
			position.y = NORMAL_HEIGHT
			card_mode = HighlightMode.NONE
			
			self.z_index = index
			card_highlight.hide()
		
		HighlightMode.HOVERED:
			card_mode = HighlightMode.HOVERED
			position.y = NORMAL_HEIGHT
			
			self.z_index = 10
			card_highlight.play("hovered")
			card_highlight.show()
		
		HighlightMode.SELECTED:
			card_mode = HighlightMode.SELECTED
			position.y = SELECTED_HEIGHT
			
			self.z_index = 11
			card_highlight.play("selected")
			card_highlight.show()
		
		HighlightMode.PLAYED:
			position.y = PLAYED_HEIGHT
			
			card_highlight.play("played")
			card_highlight.show()


## function to be called on playing the card
## 
## if the card requires targeting an enemy, add its id as the parameter
func play(target_id: int = -1) -> void:
	
	# pay energy cost
	RunData.player_stats.pay_energy(card_type.energy_cost)
	
	# return if the card cost killed the player
	if RunData.player_stats.current_hitpoints < 1:
		return
	
	var actions: Array[Action] = card_type.on_play_action
	var played_attack: bool = false
	
	# act
	for action in actions:
		
		if action is TargetedAction:
			await action.resolve(_get_targets(action.target_type, target_id))
		elif action is CardManipulationAction:
			await action.resolve([get_tree().get_first_node_in_group("card_piles")])
		elif action is SpecialAction:
			await action.resolve([get_tree().get_first_node_in_group("card_piles"), get_tree().get_first_node_in_group("player")])
			
		if action is AttackAction:
			played_attack = true
		
		action_timer.start()
		await action_timer.timeout
	
	# call the player played attack event if the card contains an attack
	if played_attack:
		EventBusHandler.player_played_attack.emit()


#region local functions

func _get_targets(targeting_mode: TargetedAction.TargetType, target_id: int) -> Array[Node2D]:
	var to_return: Array[Node2D] = []
	
	match targeting_mode:
		TargetedAction.TargetType.PLAYER:
			to_return.append(get_tree().get_first_node_in_group("player"))
		
		TargetedAction.TargetType.ENEMY_SINGLE:
			for enemy in get_tree().get_nodes_in_group("enemy"):
				if enemy.id == target_id:
					to_return.append(enemy)
					break
		
		TargetedAction.TargetType.ENEMY_ALL_INCLUSIVE:
			to_return.append_array(get_tree().get_nodes_in_group("enemy"))
		
		TargetedAction.TargetType.ENEMY_ALL_EXCLUSIVE:
			for enemy in get_tree().get_nodes_in_group("enemy"):
				if enemy.id != target_id:
					to_return.append(enemy)
		
		TargetedAction.TargetType.ENEMY_RANDOM:
			var enemies: Array[Node2D] = get_tree().get_nodes_in_group("enemy") as Array[Node2D]
			to_return.append(enemies[rng.randi_range(0, enemies.size() -1)])
		
		_:
			return []
	
	return to_return


func _set_description(icon: Texture, text: String, description_index: int) -> void:
	if 2 < description_index:
		push_error("too many descriptions for card: ", card_type.card_name)
		return
	
	if icon:
		var sprite = Sprite2D.new()
		sprite.centered = false
		sprite.texture = icon
		sprite.position = Vector2(0, 9 * description_index)
		description.add_child(sprite)
	
	if text:
		var label = Label.new()
		label.theme = MAIN_THEME
		label.text = text
		label.position = Vector2(9, (9 * description_index) + 2)
		description.add_child(label)

func _create_energy_cost_balls(amount: int) -> void:
	for i in amount:
		var new_ball = TextureRect.new()
		new_ball.texture = CARD_ENERGY_BALL
		energy_ball_container.add_child(new_ball)

#endregion

#region signal functions

func _on_mouse_entered() -> void:
	mouse_entered_card.emit(self)

func _on_mouse_exited() -> void:
	mouse_exited_card.emit(self)

func _on_card_type_energy_cost_changed(new_value: int) -> void:
	for energy_ball in energy_ball_container.get_children():
		energy_ball.queue_free()
	
	_create_energy_cost_balls(new_value)

#endregion
