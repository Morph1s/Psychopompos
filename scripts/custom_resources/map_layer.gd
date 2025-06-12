class_name MapLayer
extends Resource

enum MapLayerType { NORMAL, START, MINI_BOSS, BOSS }

@export var type: MapLayerType
@export var encounters: Array[Encounter]
