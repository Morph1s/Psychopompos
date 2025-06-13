class_name MapGenerator
extends Node

const MAX_NUM_ENCOUNTERS_PER_LAYER = 5
const MIN_NUM_ENCOUNTERS_PER_LAYER = 2
const NUM_LAYERS_BEFORE_MINI_BOSS = 4    # excluding starting layer
const NUM_LAYERS_AFTER_MINI_BOSS = 5
const NUM_WELD_ITERATIONS = (NUM_LAYERS_BEFORE_MINI_BOSS + NUM_LAYERS_AFTER_MINI_BOSS + 1) * 3

func generate_map() -> Array[MapLayer]:
	var map_layers: Array[MapLayer] = []
	
	# start layer (contains only battles)
	var start_layer = MapLayer.new()
	start_layer.type = MapLayer.MapLayerType.START
	_initial_fill_layer(start_layer)
	map_layers.append(start_layer)
	
	# first half of normal layers
	for layer in NUM_LAYERS_BEFORE_MINI_BOSS:
		var map_layer = MapLayer.new()
		map_layer.type = MapLayer.MapLayerType.NORMAL
		_initial_fill_layer(map_layer)
		map_layers.append(map_layer)
	
	# mini boss layer
	var mini_boss_layer = MapLayer.new()
	mini_boss_layer.type = MapLayer.MapLayerType.MINI_BOSS
	
	var mini_boss_encounter = Encounter.new()
	#mini_boss_encounter.type = Encounter.EncounterType.BATTLE
	mini_boss_layer.encounters.append(mini_boss_encounter)
	
	map_layers.append(mini_boss_layer)
	
	# second half of normal layers
	for layer in NUM_LAYERS_AFTER_MINI_BOSS:
		var map_layer = MapLayer.new()
		map_layer.type = MapLayer.MapLayerType.NORMAL
		_initial_fill_layer(map_layer)
		map_layers.append(map_layer)
	
	# boss layer
	var boss_layer = MapLayer.new()
	boss_layer.type = MapLayer.MapLayerType.BOSS
	
	var boss_encounter = Encounter.new()
	#boss_encounter.type = Encounter.EncounterType.BATTLE
	boss_layer.encounters.append(boss_encounter)
	
	map_layers.append(boss_layer)
	
	# set initial connections
	_set_initial_connections(map_layers)
	
	for i in NUM_WELD_ITERATIONS:
		_weld_iteration(map_layers)
	
	return map_layers

func _initial_fill_layer(layer: MapLayer):
	for i in MAX_NUM_ENCOUNTERS_PER_LAYER:
		var encounter: Encounter = Encounter.new()
		layer.encounters.append(encounter)

func _set_initial_connections(map_layers: Array[MapLayer]):
	for layer: MapLayer in map_layers:
		# the last layer (boss layer) should not have any outgoing connections
		if layer.type == MapLayer.MapLayerType.BOSS:
			break
		
		# we need the following layer to connect encounters
		var next_layer = map_layers[map_layers.find(layer) + 1]
		
		# if the following layer is the mini boss or boss layer, connect every encounter to the mini boss or boss encounter
		# if this layer is the mini boss layer, also connect it to all encounters of the following layer
		if ((next_layer.type == MapLayer.MapLayerType.MINI_BOSS) 
		or (next_layer.type == MapLayer.MapLayerType.BOSS)
		or (layer.type == MapLayer.MapLayerType.MINI_BOSS)):
			for encounter: Encounter in layer.encounters:
				encounter.connections_to = next_layer.encounters
			continue
		
		# in all other cases, connect the first encounter of this layer to the first of the next, the second of this to the second of the next, etc.
		for encounter: Encounter in layer.encounters:
			encounter.connections_to.append(next_layer.encounters[layer.encounters.find(encounter)])

func _weld_iteration(map_layers: Array[MapLayer]):
	# choose a random layer
	var layer = map_layers[randi_range(0, map_layers.size() - 1)]
	
	# the chosen layer needs at least 2 encounter nodes
	# mini boss and boss layers have only one, so we dont need to check them separately
	if layer.encounters.size() > MIN_NUM_ENCOUNTERS_PER_LAYER:
		# choose a random encounter in the layer, that has at least one encounter with a higher index
		var node_1: Encounter = layer.encounters[randi_range(0, layer.encounters.size() - 2)]
		var node_2: Encounter = layer.encounters[layer.encounters.find(node_1) + 1]
		# transfer the connections from node_2 to node_1
		for encounter: Encounter in node_2.connections_to:
			if not node_1.connections_to.has(encounter):
				node_1.connections_to.append(encounter)
		# transfer the connections to node_2 to node_1
		if not layer.type == MapLayer.MapLayerType.START:
			var previous_layer = map_layers[map_layers.find(layer) - 1]
			for encounter: Encounter in previous_layer.encounters:
				if encounter.connections_to.has(node_2) and not encounter.connections_to.has(node_1):
					encounter.connections_to.erase(node_2)
					encounter.connections_to.append(node_1)
		# delete node_2 from the layer
		layer.encounters.erase(node_2)
