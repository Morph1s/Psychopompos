class_name MapLayer
extends Resource

enum MapLayerType {
	NORMAL,
	START,
	MINI_BOSS,
	BOSS,
	}

var type: MapLayerType
var nodes: Array[MapNode]
var layer_index: int
