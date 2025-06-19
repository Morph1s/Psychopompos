class_name Enemy
extends Area2D

signal action_resolved
signal mouse_entered_enemy(Node)
signal mouse_exited_enemy(Node)
signal enemy_died(Node)

@onready var image: Sprite2D = $EnemyImage
@onready var shape: CollisionShape2D = $EnemyShape
@onready var modifier_handler: ModifierHandler = $ModifierHandler
@onready var effect_handler = $EffectHandler

@export var stats: EnemyStats
@export var enemy_hud: EnemyHud

var id: int = 0
var intent: int = -1 # Damit in Runde eins der intent auf null erhöht werden kann
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var y_position: int = 55
var size: Vector2

func initialize() -> void:
	
	stats.set_modifier_handler(modifier_handler)
	image.texture = stats.enemy_sprite
	
	size = image.texture.get_size()
	shape.shape.size = size
	shape.position = size / 2
	enemy_hud.set_entity_size(size)
	effect_handler.position.x = size.x
	
	# update position for larger enemies
	y_position -= size.y - 48
	
	# Connecting Signals
	stats.hitpoints_changed.connect(_on_hitpoints_changed)
	stats.block_changed.connect(_on_block_changed)
	stats.died.connect(_on_died)
	
	stats.initialize()
	
	effect_handler.initialize(self)

func start_of_turn() -> void:
	stats.block = 0
	effect_handler._on_unit_turn_start()

func end_of_turn() -> void:
	effect_handler._on_unit_turn_end()

func take_damage(amount:int) -> void:
	amount = modifier_handler.modify_value(amount, ModifierHandler.ModifiedValue.DAMAGE_TAKEN)
	stats.take_damage(amount)

func lose_hp(amount: int) -> void:
	stats.lose_hp(amount)

func gain_block(amount: int) -> void:
	stats.block += amount

func get_attacked(damage_amount: int) -> void:
	take_damage(damage_amount)
	effect_handler._on_unit_get_attacked()

func resolve_intent() -> void:
	var actions: Array[Action] = stats.actions[intent].action_catalogue
	var attacked: bool = false
	
	for action in actions:
		if action is TargetedAction:
			action.resolve(_get_targets(action.target_type))
		elif action is CardManipulationAction:
			action.resolve([get_tree().get_first_node_in_group("card_piles")])
		if action is AttackAction:
			attacked = true
	
	if attacked:
		effect_handler._on_unit_played_attack()
	
	action_resolved.emit()

func choose_intent() -> void:
	if stats.action_pattern == stats.ActionPattern.LINEAR :
		intent += 1
		if intent >= stats.actions.size():
			intent = 0
	elif stats.action_pattern == stats.ActionPattern.RANDOM: 
		intent = rng.randi_range(0,stats.actions.size()-1)
	
	enemy_hud.set_intent(stats.actions[intent].intent_sprite, stats.actions[intent].value, stats.actions[intent].count)

#region local functions

func _get_targets(targeting_mode: TargetedAction.TargetType) -> Array[Node2D]:
	var to_return: Array[Node2D] = []
	
	if targeting_mode == TargetedAction.TargetType.PLAYER:
		to_return.append(get_tree().get_first_node_in_group("player"))
		
	elif targeting_mode == TargetedAction.TargetType.ENEMY_SINGLE:
		to_return.append(self)
		
	elif targeting_mode == TargetedAction.TargetType.ENEMY_ALL_INCLUSIVE:
		to_return.append_array(get_tree().get_nodes_in_group("enemy"))
		
	elif targeting_mode == TargetedAction.TargetType.ENEMY_ALL_EXCLUSIVE:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.id != id:
				to_return.append(enemy)
		
	elif targeting_mode == TargetedAction.TargetType.ENEMY_RANDOM:
		var enemies := get_tree().get_nodes_in_group("enemy")
		to_return.append(enemies[rng.randi_range(0, enemies.size() -1)])
	
	return to_return

#endregion

#region Signal Methods
func _on_hitpoints_changed(new_hp: int, max_hp: int) -> void:
	enemy_hud.set_current_hp(new_hp)
	enemy_hud.set_max_hp(max_hp)

func _on_block_changed(new_block) -> void:
	enemy_hud.set_block(new_block)

func _on_died() -> void:
	enemy_died.emit(self)

func _on_mouse_entered() -> void:
	mouse_entered_enemy.emit(self)

func _on_mouse_exited() -> void:
	mouse_exited_enemy.emit(self)
#endregion
