class_name EnemyHud
extends EntityHud

const ENEMY_HP_BAR_OVER = preload("res://assets/graphics/hud/hp_bar/enemy_hp_bar_over.png")

@onready var intent_container = $IntentContainer
@onready var intent_icon = $IntentContainer/IntentIcon
@onready var intent_value = $IntentContainer/IntentValue


func set_intent(icon: Texture, value: int, amount: int = 1) -> void:
	intent_container.show()
	intent_icon.texture = icon
	if value == 0:
		intent_value.text = ""
	elif amount == 1:
		intent_value.text = str(value)
	else:
		intent_value.text = "%d*%d" % [value, amount]

func _set_hp_bar_border() -> void:
	if current_block:
		hp_bar.texture_over = ENTITY_DEFEND_BAR_OVER
	else:
		hp_bar.texture_over = ENEMY_HP_BAR_OVER
