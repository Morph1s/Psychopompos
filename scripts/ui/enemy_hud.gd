class_name EnemyHud
extends EntityHud

@onready var intent_container = $IntentContainer
@onready var intent_icon = $IntentContainer/IntentIcon
@onready var intent_value = $IntentContainer/IntentValue

func set_intent(icon: Texture, value: int, amount: int = 1) -> void:
	intent_icon.texture = icon
	if amount == 1:
		intent_value.text = str(value)
	else:
		intent_value.text = "%d*%d" % [value, amount]
