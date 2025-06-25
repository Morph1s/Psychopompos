class_name MapLayer
extends Resource

enum MapLayerType {
	NORMAL,
	START,
	MINI_BOSS,
	BOSS,
	}

# TODO: remove @export before push
@export var type: MapLayerType
@export var nodes: Array[MapNode]
@export var layer_index: int
