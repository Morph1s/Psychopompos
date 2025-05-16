class_name EncounterHandler
extends Node2D

var current_encounter: Node = null

# Loads a requested encounter into the Run scene
func start_encounter(encounter_data):
	# Remove current encounter if exists
	if current_encounter:
		current_encounter.queue_free()
		current_encounter = null
		# a wonderful fix for a race condition
		await get_tree().create_timer(0.1).timeout
	
	# Load requested encounter if implemented
	match encounter_data:
		"battle":
			var battle_scene = preload("res://scenes/encounters/battle.tscn").instantiate()
			add_child(battle_scene)
			current_encounter = battle_scene
		_:
			print("Encounter type not implemented: ", encounter_data)
