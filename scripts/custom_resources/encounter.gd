class_name Encounter
extends Resource

enum EncounterType { BATTLE, SHOP, CAMPFIRE, RANDOM, MINI_BOSS, BOSS }

@export var type: EncounterType
@export var connections_to: Array[Encounter]  # connections to next encounter(s)
@export var completed: bool = false           # only possible to go to next encounter if true
@export var position: Vector2                 # positioning on the graphical map
