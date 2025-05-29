class_name EnemyHud
extends EntityHud

@onready var intent_indicator: TextureRect = $IntentIndicator

func set_intent(texture: Texture) -> void:
	intent_indicator.texture = texture

func _update_display() -> void:
	super._update_display()

func initiliaze() -> void:
	set_intent(preload("res://assets/graphics/ui/placeholder_intent_heal.png"))
