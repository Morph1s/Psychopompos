class_name EnemyHud
extends EntityHud

@onready var intent_indicator: TextureRect = $IntentIndicator

func set_intent(texture: Texture) -> void:
	intent_indicator.texture = texture
