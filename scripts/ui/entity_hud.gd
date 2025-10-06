extends Control
class_name EntityHud

@onready var hp_bar: TextureProgressBar = $HpBar
@onready var hitpoint_label: Label = $HpBar/LabelContainer/Hitpoints
@onready var block_label: Label = $HpBar/LabelContainer/Block
@onready var hitpoint_changes_container: VBoxContainer = $HpBar/HitpointChangesContainer

const PLAYER_HP_BAR_OVER: Texture = preload("res://assets/graphics/hud/hp_bar/player_hp_bar_over.png")
const ENTITY_DEFEND_BAR_OVER: Texture = preload("res://assets/graphics/hud/hp_bar/entity_defend_bar_over.png")

const MAX_HITPOINT_CHANGE_LABELS: int = 5

@export var hp_loss_label_color: Color = Color("ff0000")
@export var hp_heal_label_color: Color = Color("00ff00")
@export var block_loss_label_color: Color = Color("bcc0d9")

var current_hp: int = 0
var max_hp: int = 100
var current_block: int = 0


func set_initial_values(max_hp_value: int, current_hp_value: int, block_value: int) -> void:
	max_hp = max_hp_value
	hp_bar.max_value = max_hp_value
	current_hp = current_hp_value
	hp_bar.value = current_hp_value
	current_block = block_value
	_update_display()

func set_current_hp(value: int) -> void:
	_create_hp_change_label(value - current_hp)
	current_hp = value
	hp_bar.value = value
	_update_display()

func set_max_hp(value: int) -> void:
	max_hp = value
	hp_bar.max_value = value
	_update_display()

func set_block(value: int) -> void:
	_create_block_change_label(value - current_block)
	current_block = value
	_set_hp_bar_border()
	_update_display()

func _update_display() -> void:
	hitpoint_label.text = str(current_hp)
	
	if current_block:
		block_label.text = "+%d" % [current_block]
		block_label.show()
	else:
		block_label.hide()

func set_entity_size(size: Vector2) -> void:
	custom_minimum_size = size + Vector2(0, 8)

func _set_hp_bar_border() -> void:
	if current_block:
		hp_bar.texture_over = ENTITY_DEFEND_BAR_OVER
	else:
		hp_bar.texture_over = PLAYER_HP_BAR_OVER

func _create_hp_change_label(change: int) -> void:
	if change == 0:
		return
	
	var label := Label.new()
	
	if 0 < change:
		label.add_theme_color_override("font_color", hp_heal_label_color)
		label.text = "+%d" % [change]
	else:
		label.add_theme_color_override("font_color", hp_loss_label_color)
		label.text = str(change)
	
	hitpoint_changes_container.add_child(label)
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 2.5)
	tween.tween_callback(label.queue_free)

func _create_block_change_label(change: int) -> void:
	if not change < 0:
		return
	
	var label := Label.new()
	label.add_theme_color_override("font_color", block_loss_label_color)
	label.text = str(change)
	hitpoint_changes_container.add_child(label)
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 2.0)
	tween.tween_callback(label.queue_free)

func _on_hitpoint_changes_container_child_entered_tree(node: Control) -> void:
	if hitpoint_changes_container.get_child_count() > MAX_HITPOINT_CHANGE_LABELS:
		hitpoint_changes_container.get_child(0).free()
