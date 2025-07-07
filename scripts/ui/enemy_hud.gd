class_name EnemyHud
extends EntityHud

const ENEMY_HP_BAR_OVER = preload("res://assets/graphics/hud/hp_bar/enemy_hp_bar_over.png")

@onready var intent_container = $IntentContainer
@onready var intent_icon = $IntentContainer/IntentIcon
@onready var intent_value = $IntentContainer/IntentValue
@onready var intent_amount = $IntentContainer/IntentAmount


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
