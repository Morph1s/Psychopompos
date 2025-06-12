class_name MapGenerator
extends Node

func generate_map() -> Array[MapLayer]:
	var map_layers: Array[MapLayer] = []
	
	# start layer (contains only battles)
	var start_layer = MapLayer.new()
	start_layer.type = MapLayer.MapLayerType.START
	
	var start_layer_num_encounters = randi_range(2, 5)
	for i in range(start_layer_num_encounters):
		var encounter = Encounter.new()
		encounter.type = Encounter.EncounterType.BATTLE
		start_layer.encounters.append(encounter)
	
	map_layers.append(start_layer)
	
	# first half of normal layers
	for layer in range(5):
		var map_layer = MapLayer.new()
		map_layer.type = MapLayer.MapLayerType.NORMAL
		
		var num_encounters = randi_range(2, 5)
		for i in range(num_encounters):
			var encounter = Encounter.new()
			encounter.type = Encounter.EncounterType.BATTLE
			map_layer.encounters.append(encounter)
		
		map_layers.append(map_layer)
	
	# mini boss layer
	var mini_boss_layer = MapLayer.new()
	mini_boss_layer.type = MapLayer.MapLayerType.MINI_BOSS
	
	var mini_boss_encounter = Encounter.new()
	mini_boss_encounter.type = Encounter.EncounterType.BATTLE
	mini_boss_layer.encounters.append(mini_boss_encounter)
	
	map_layers.append(mini_boss_layer)
	
	# second half of normal layers
	for layer in range(5):
		var map_layer = MapLayer.new()
		map_layer.type = MapLayer.MapLayerType.NORMAL
		
		var num_encounters = randi_range(2, 5)
		for i in range(num_encounters):
			var encounter = Encounter.new()
			encounter.type = Encounter.EncounterType.BATTLE
			map_layer.encounters.append(encounter)
		
		map_layers.append(map_layer)
	
	# boss layer
	var boss_layer = MapLayer.new()
	boss_layer.type = MapLayer.MapLayerType.BOSS
	
	var boss_encounter = Encounter.new()
	boss_encounter.type = Encounter.EncounterType.BATTLE
	boss_layer.encounters.append(boss_encounter)
	
	map_layers.append(boss_layer)
	
	# set connections
	for layer in range(len(map_layers) - 1):
		# if next layer is the mini boss, set all connections to the mini boss encounter
		if map_layers[layer + 1].type == MapLayer.MapLayerType.MINI_BOSS:
			for encounter: Encounter in map_layers[layer].encounters:
				encounter.connections_to = map_layers[layer + 1].encounters
			continue
		
		# if next layer is the boss, set all connections to the boss encounter
		elif map_layers[layer + 1].type == MapLayer.MapLayerType.BOSS:
			for encounter: Encounter in map_layers[layer].encounters:
				encounter.connections_to = map_layers[layer + 1].encounters
			continue
		
		# if this layer ist the mini boss, set connections to all encounters of the next layer
		elif map_layers[layer].type == MapLayer.MapLayerType.MINI_BOSS:
			for encounter: Encounter in map_layers[layer].encounters:
				encounter.connections_to = map_layers[layer + 1].encounters
		
		# if next layer is a normal layer, set random connections
		else:
			for encounter: Encounter in map_layers[layer].encounters:
				var next_encounters = map_layers[layer + 1].encounters.duplicate()
				next_encounters.shuffle()
				var num_next_encounters = randi_range(1, 3)
				encounter.connections_to = next_encounters.slice(0, min(num_next_encounters, next_encounters.size()))
	
	return map_layers
