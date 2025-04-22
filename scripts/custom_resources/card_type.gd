class_name CardType
extends Resource

@export var texture : Texture
@export var on_play_action : Array[Action]
@export var on_graveyard_action : Array[Action]

func create_instance() -> CardType:
	var new_entity = self.duplicate()
	return new_entity
