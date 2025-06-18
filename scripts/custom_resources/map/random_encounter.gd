class_name RandomEncounter
extends Encounter

func _init() -> void:
	type = EncounterType.RANDOM
	icon = load("res://assets/graphics/map/icon_random.png")
