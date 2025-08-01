class_name EnemyHud
extends EntityHud

signal intent_box_hovered(mouse_entered: bool)

@onready var intent_container: HBoxContainer = $IntentContainer
@onready var intent_icon: TextureRect = $IntentContainer/IntentIcon
@onready var intent_value: Label = $IntentContainer/IntentValue
@onready var intent_amount: Label = $IntentContainer/IntentAmount

const ENEMY_HP_BAR_OVER: Texture = preload("res://assets/graphics/hud/hp_bar/enemy_hp_bar_over.png")


func set_intent(icon: Texture, value: int, value_text_color: Color, amount: int = 1) -> void:
	intent_container.size.x = custom_minimum_size.x
	
	intent_container.show()
	intent_icon.texture = icon
	
	intent_value.add_theme_color_override("font_color", value_text_color)
	
	if value == 0:
		intent_value.text = ""
	elif amount == 1:
		intent_value.text = str(value)
	else:
		intent_value.text = "%d" % [value]
	
	if amount > 1:
		intent_amount.text = "*%d" % [amount]
		intent_amount.show()
	else:
		intent_amount.hide()

func _set_hp_bar_border() -> void:
	if current_block:
		hp_bar.texture_over = ENTITY_DEFEND_BAR_OVER
	else:
		hp_bar.texture_over = ENEMY_HP_BAR_OVER

#region mouse_interaction

func _on_intent_container_mouse_entered() -> void:
	intent_box_hovered.emit(true)

func _on_intent_container_mouse_exited() -> void:
	intent_box_hovered.emit(false)

#endregion
