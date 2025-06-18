class_name Encounter
extends Resource

enum EncounterType { BATTLE, SHOP, CAMPFIRE, DIALOGUE, RANDOM, MINI_BOSS, BOSS }

var type: EncounterType
var connections_to: Array[Encounter]  # connections to next encounter(s)
var completed: bool = false           # only possible to go to next encounter if true
var position: Vector2                 # positioning on the graphical map
var icon: Texture
