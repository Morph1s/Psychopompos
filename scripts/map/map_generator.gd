class_name MapGenerator
extends Node

# const values for graph generation
const MAX_NUM_NODES_PER_LAYER: int = 5
const NUM_LAYERS_BEFORE_MINI_BOSS: int = 4		# excluding starting layer
const NUM_LAYERS_AFTER_MINI_BOSS: int = 5
const NUM_GENERATED_PATHS: int = 6				# CANNOT BE SMALLER THAN 2! - number of iterations of the path generation
const MAX_OVERLAPPING_NODES_IN_PATHS: int = 2

# const values for encounter placement
const MIN_NUM_CAMPFIRE_ENCOUNTERS: int = 2
const MIN_LAYER_ID_CAMPFIRE_PLACEMENT: int = 2
const MIN_NUM_LAYERS_BETWEEN_CAMPFIRES: int = 1
const MAX_NUM_CONSECUTIVE_BATTLES: int = 4
const MAX_NUM_CONSECUTIVE_RANDOM_ENCOUNTERS: int = 2
const STARTING_LAYER_ONLY_CONTAINS_BATTLES: bool = true

var rng: RandomNumberGenerator = RunData.sub_rngs["rng_map_gen"]
var map: Array[MapLayer] = []
var paths: Array[MapPath] = []


func generate_map() -> Array[MapLayer]:
	build_map_layers()
	generate_map_paths()
	hide_excluded_nodes()
	place_encounters()
	return map

### GENERATE MAP LAYERS ###

func build_map_layers():
	# starting layer
	var starting_layer: MapLayer = MapLayer.new()
	starting_layer.type = MapLayer.MapLayerType.START
	map.append(starting_layer)
	
	# normal layers before mini boss
	for l in NUM_LAYERS_BEFORE_MINI_BOSS:
		var layer: MapLayer = MapLayer.new()
		layer.type = MapLayer.MapLayerType.NORMAL
		map.append(layer)
	
	# mini boss layer
	var mini_boss_layer: MapLayer = MapLayer.new()
	mini_boss_layer.type = MapLayer.MapLayerType.MINI_BOSS
	map.append(mini_boss_layer)
	
	# normal layers after mini boss
	for l in NUM_LAYERS_AFTER_MINI_BOSS:
		var layer: MapLayer = MapLayer.new()
		layer.type = MapLayer.MapLayerType.NORMAL
		map.append(layer)
	
	# boss layer
	var boss_layer: MapLayer = MapLayer.new()
	boss_layer.type = MapLayer.MapLayerType.BOSS
	map.append(boss_layer)
	
	# fill the map with nodes
	fill_map_layers()

func fill_map_layers():
	for layer: MapLayer in map:
		# mini boss and boss layers only contain one encounter each
		if layer.type == MapLayer.MapLayerType.MINI_BOSS or layer.type == MapLayer.MapLayerType.BOSS:
			layer.nodes.append(MapNode.new())
			continue
		
		# every other layer contains the max number of nodes
		for n in MAX_NUM_NODES_PER_LAYER:
			layer.nodes.append(MapNode.new())

### GENERATE MAP PATHS ###

func generate_map_paths():
	_generate_first_path()
	_generate_second_path()
	
	for path in NUM_GENERATED_PATHS - 3:
		_generate_single_path()
	
	_generate_single_path()

func _generate_first_path():
	var path: MapPath = MapPath.new()
	var previous_index: int
	
	for layer: MapLayer in map:
		# when reaching the boss layer, break
		if layer.type == MapLayer.MapLayerType.BOSS:
			var node: MapNode = layer.nodes[0]
			path.nodes.append(node)
			break
		
		# for starting layer just choose a random node
		if layer.type == MapLayer.MapLayerType.START:
			var nodes: Array[MapNode] = layer.nodes.duplicate()
			var node: MapNode = nodes[rng.randi_range(0, nodes.size() - 2)]
			path.nodes.append(node)
			previous_index = layer.nodes.find(node)
			continue
		
		# for mini boss layer, choose the only encounter in layer.nodes
		if layer.type == MapLayer.MapLayerType.MINI_BOSS:
			var node: MapNode = layer.nodes[0]
			path.nodes.append(node)
			continue
		
		var min_index: int = max(0, previous_index - 1)
		var max_index: int = min(previous_index + 1, MAX_NUM_NODES_PER_LAYER - 2)
		
		var node: MapNode = layer.nodes[rng.randi_range(min_index, max_index)]
		path.nodes.append(node)
		previous_index = layer.nodes.find(node)
	
	paths.append(path)
	_add_connections_from_path(path)

func _generate_second_path():
	var path: MapPath = MapPath.new()
	var previous_index: int
	
	for layer: MapLayer in map:
		# when reaching the boss layer, break
		if layer.type == MapLayer.MapLayerType.BOSS:
			var node: MapNode = layer.nodes[0]
			path.nodes.append(node)
			break
		
		# for starting layer, choose a random point
		if layer.type == MapLayer.MapLayerType.START:
			var nodes: Array[MapNode] = layer.nodes.duplicate()
			var first_path_first_node_index: int = layer.nodes.find(paths[0].nodes[0])
			var node: MapNode = nodes[rng.randi_range(first_path_first_node_index + 1, nodes.size() - 1)]
			path.nodes.append(node)
			previous_index = layer.nodes.find(node)
			continue
		
		# for mini boss layer, choose the only encounter in layer.nodes
		if layer.type == MapLayer.MapLayerType.MINI_BOSS:
			var node: MapNode = layer.nodes[0]
			path.nodes.append(node)
			continue
		
		var min_index: int = max(_get_min_index_for_second_path(map.find(layer)), previous_index - 1)
		var max_index: int = min(previous_index + 1, MAX_NUM_NODES_PER_LAYER - 1)
		
		var node: MapNode = layer.nodes[rng.randi_range(min_index, max_index)]
		path.nodes.append(node)
		previous_index = layer.nodes.find(node)
	
	paths.append(path)
	_add_connections_from_path(path)

func _get_min_index_for_second_path(layer_index: int) -> int:
	var first_path: MapPath = paths[0]
	var current_layer: MapLayer = map[layer_index]
	var node_first_path_current_layer: MapNode = first_path.nodes[layer_index]
	
	return current_layer.nodes.find(node_first_path_current_layer) + 1

func _generate_single_path():
	var path: MapPath = MapPath.new()
	var previous_index: int
	
	for layer: MapLayer in map:
		# when reaching the boss layer, break
		if layer.type == MapLayer.MapLayerType.BOSS:
			var node: MapNode = layer.nodes[0]
			path.nodes.append(node)
			break
		
		# for starting layer just choose a random node
		if layer.type == MapLayer.MapLayerType.START:
			var node: MapNode = layer.nodes[rng.randi_range(0, layer.nodes.size() - 1)]
			path.nodes.append(node)
			previous_index = layer.nodes.find(node)
			continue
		
		# for mini boss layer, choose the only encounter in layer.nodes
		if layer.type == MapLayer.MapLayerType.MINI_BOSS:
			var node: MapNode = layer.nodes[0]
			path.nodes.append(node)
			continue
		
		var min_index: int = max(_get_min_node_index(map.find(layer), previous_index), previous_index - 1)
		var max_index: int = min(previous_index + 1, _get_max_node_index(map.find(layer), previous_index))
		
		var available_nodes: Array[MapNode] = layer.nodes.slice(min_index, max_index + 1)
		var overlapping_paths: Array[MapPath] = _check_path_overlap(path, path.nodes.size() - 1)
		_remove_nodes_from_overlapping_paths(overlapping_paths, available_nodes, path.nodes.size())
		
		var node: MapNode = layer.nodes[rng.randi_range(min_index, max_index)]
		path.nodes.append(node)
		previous_index = layer.nodes.find(node)
	
	paths.append(path)
	_add_connections_from_path(path)

func _get_min_node_index(layer_index: int, current_node_index: int) -> int:
	var last_layer_index: int = layer_index - 1
	var last_layer: MapLayer = map.get(last_layer_index)
	if last_layer.type == MapLayer.MapLayerType.MINI_BOSS:
		last_layer = map.get(layer_index - 2)
		last_layer_index = layer_index - 2
	var current_layer: MapLayer = map.get(layer_index)
	var nodes_in_path_in_last_layer: Array[MapNode] = _get_nodes_in_path_in_layer(last_layer_index)
	var next_smaller_node_in_a_path: MapNode
	var min_index: int = 0
	var next_nodes: Array[MapNode] = []
	
	for node: MapNode in nodes_in_path_in_last_layer:
		if last_layer.nodes.find(node) < current_node_index:
			if (next_smaller_node_in_a_path != null) and (last_layer.nodes.find(node) < last_layer.nodes.find(next_smaller_node_in_a_path)):
				continue
			next_smaller_node_in_a_path = node
	
	# edge case: if last layer is mini boss layer
	if map.get(layer_index - 1).type == MapLayer.MapLayerType.MINI_BOSS:
		var paths_containing_node: Array[MapPath] = _get_all_paths_containing_node(next_smaller_node_in_a_path)
		for path: MapPath in paths_containing_node:
			if not next_nodes.has(path.nodes[layer_index]):
				next_nodes.append(path.nodes[layer_index])
	
	if next_smaller_node_in_a_path != null:
		next_nodes = next_smaller_node_in_a_path.next_nodes
	
	for node: MapNode in next_nodes:
		if current_layer.nodes.find(node) > min_index:
			min_index = current_layer.nodes.find(node)
	
	return min_index

func _get_max_node_index(layer_index: int, current_node_index: int) -> int:
	var last_layer_index: int = layer_index - 1
	var last_layer: MapLayer = map.get(last_layer_index)
	if last_layer.type == MapLayer.MapLayerType.MINI_BOSS:
		last_layer = map.get(layer_index - 2)
		last_layer_index = layer_index - 2
	var current_layer: MapLayer = map.get(layer_index)
	var nodes_in_path_in_last_layer: Array[MapNode] = _get_nodes_in_path_in_layer(last_layer_index)
	var next_bigger_node_in_a_path: MapNode
	var max_index: int = MAX_NUM_NODES_PER_LAYER - 1
	var next_nodes: Array[MapNode] = []
	
	for node: MapNode in nodes_in_path_in_last_layer:
		if last_layer.nodes.find(node) > current_node_index:
			if (next_bigger_node_in_a_path != null) and (last_layer.nodes.find(node) > last_layer.nodes.find(next_bigger_node_in_a_path)):
				continue
			next_bigger_node_in_a_path = node
	
	# edge case: if last layer is mini boss layer
	if map.get(layer_index - 1).type == MapLayer.MapLayerType.MINI_BOSS:
		var paths_containing_node: Array[MapPath] = _get_all_paths_containing_node(next_bigger_node_in_a_path)
		for path: MapPath in paths_containing_node:
			if not next_nodes.has(path.nodes[layer_index]):
				next_nodes.append(path.nodes[layer_index])
	
	elif next_bigger_node_in_a_path != null:
		next_nodes = next_bigger_node_in_a_path.next_nodes
	
	for node: MapNode in next_nodes:
		if current_layer.nodes.find(node) < max_index:
			max_index = current_layer.nodes.find(node)
	
	return max_index

func _get_nodes_in_path_in_layer(layer_index: int) -> Array[MapNode]:
	var result: Array[MapNode] = []
	
	for path: MapPath in paths:
		if not result.has(path.nodes[layer_index]):
			result.append(path.nodes[layer_index])
	
	return result

func _get_all_paths_containing_node(node: MapNode) -> Array[MapPath]:
	var result: Array[MapPath] = []
	
	for path: MapPath in paths:
		if path.nodes.has(node):
			result.append(path)
	
	return result

func _check_path_overlap(current_path: MapPath, index: int) -> Array[MapPath]:
	var result: Array[MapPath] = []
	
	for path: MapPath in paths:
		if path.nodes[index] != current_path.nodes[index]:
			continue
		for i in MAX_OVERLAPPING_NODES_IN_PATHS - 1:
			if path.nodes[index - i] != current_path.nodes[index - i]:
				break
			result.append(path)
	
	return result

func _remove_nodes_from_overlapping_paths(paths: Array[MapPath], nodes: Array[MapNode], index: int):
	for path: MapPath in paths:
		if nodes.has(path.nodes[index]):
			nodes.erase(path.nodes[index])

func _add_connections_from_path(path: MapPath):
	for node: MapNode in path.nodes:
		if (path.nodes.find(node) + 1) < path.nodes.size() and not node.next_nodes.has(path.nodes.get(path.nodes.find(node) + 1)):
			node.next_nodes.append(path.nodes.get(path.nodes.find(node) + 1))

func hide_excluded_nodes():
	for layer: MapLayer in map:
		# skip boss layer
		if layer.type == MapLayer.MapLayerType.BOSS:
			break
		
		for node: MapNode in layer.nodes:
			if node.next_nodes.is_empty():
				node.active = false

### PLACE ENCOUNTERS ###

func place_encounters():
	_place_mini_boss_encounter()
	_place_boss_encounter()
	_place_min_num_campfires()
	_place_encounters()

func _place_mini_boss_encounter():
	map[NUM_LAYERS_BEFORE_MINI_BOSS + 1].nodes[0].encounter = MiniBossEncounter.new()

func _place_boss_encounter():
	map.back().nodes[0].encounter = BossEncounter.new()

func _place_min_num_campfires():
	for i in MIN_NUM_CAMPFIRE_ENCOUNTERS:
		var path: MapPath = paths[rng.randi_range(0, paths.size() - 1)]
		var node: MapNode = _choose_random_node_for_encounter_in_path(path, MIN_LAYER_ID_CAMPFIRE_PLACEMENT, Encounter.EncounterType.CAMPFIRE)
		node.encounter = CampfireEncounter.new()
		_update_campfire_weights_two_way(node)

func _place_encounters():
	if STARTING_LAYER_ONLY_CONTAINS_BATTLES:
		for node: MapNode in map[0].nodes:
			if node.active:
				node.encounter = BattleEncounter.new()
	
	for layer: MapLayer in map:
		for node: MapNode in layer.nodes:
			if node.encounter != null or not node.active:
				continue
			
			var encounter = _choose_weighted_encounter(node)
			
			match encounter:
				Encounter.EncounterType.BATTLE:
					node.encounter = BattleEncounter.new()
				Encounter.EncounterType.CAMPFIRE:
					node.encounter = CampfireEncounter.new()
				Encounter.EncounterType.RANDOM:
					node.encounter = RandomEncounter.new()
				_:
					print("Encounter type not implemented: ", Encounter.EncounterType.find_key(encounter))
					break
			
			_update_encounter_weights_up(node)

func _choose_random_node_for_encounter_in_path(path: MapPath, min_layer_index: int, type: Encounter.EncounterType) -> MapNode:
	var viable_nodes: Array[MapNode] = path.nodes.duplicate()
	
	# slice at min layer index
	viable_nodes = viable_nodes.slice(min_layer_index)
	
	# remove all nodes from viable nodes that already have an encounter set
	for i in range(viable_nodes.size() - 1, -1, -1):
		var node: MapNode = viable_nodes[i]
		if node.encounter != null:
			viable_nodes.erase(node)
	
	# remove all nodes where the wanted encounter types weight is 0
	for i in range(viable_nodes.size() - 1, -1, -1):
		var node: MapNode = viable_nodes[i]
		if node.encounter_weights[type] == 0:
			viable_nodes.erase(node)
	
	return viable_nodes[rng.randi_range(0, viable_nodes.size() - 1)]

func _choose_weighted_encounter(node: MapNode):
	var encounters: Array = node.encounter_weights.keys()
	var cum_weights: Array[int] = node.encounter_weights.values().duplicate()
	
	for w in cum_weights.size():
		if 0 < w:
			cum_weights[w] += cum_weights[w - 1]
	
	var random_index: int = rng.randi_range(0, cum_weights.back())
	
	for w in cum_weights:
		if w >= random_index:
			return encounters[cum_weights.find(w)]

func _update_campfire_weights_two_way(current_node: MapNode):
	var paths_containing_node: Array[MapPath] = _get_paths_containing_node(current_node)
	
	# this would be an error, just continue map generation
	if paths_containing_node.is_empty():
		return
	
	# get the layer index of current_node, this is the same in all paths containing it
	var layer_index: int = paths_containing_node[0].nodes.find(current_node)
	
	# adjust weights
	for path: MapPath in paths_containing_node:
		# up the path
		for i in range(layer_index + 1, layer_index + MIN_NUM_LAYERS_BETWEEN_CAMPFIRES + 1):
			var node: MapNode = path.nodes.get(i)
			if node.encounter != null:
				continue
			
			_adjust_encounter_weights(node, Encounter.EncounterType.CAMPFIRE, -100)
		
		# down the path
		for i in range(layer_index - 1, layer_index - MIN_NUM_LAYERS_BETWEEN_CAMPFIRES - 1, -1):
			var node: MapNode = path.nodes.get(i)
			if node.encounter != null:
				continue
			
			_adjust_encounter_weights(node, Encounter.EncounterType.CAMPFIRE, -100)

func _update_encounter_weights_up(current_node: MapNode) -> void:
	var paths_containing_node: Array[MapPath] = _get_paths_containing_node(current_node)
	
	# this would be an error, just continue map generation
	if paths_containing_node.is_empty():
		return
	
	# get the layer index of current_node, this is the same in all paths containing it
	var layer_index: int = paths_containing_node[0].nodes.find(current_node)
	
	for path: MapPath in paths_containing_node:
		var next_node: MapNode = path.nodes[layer_index + 1]
		
		if next_node.encounter != null:
			continue
		
		var current_encounter_weight: int = current_node.encounter_weights[current_node.encounter.type]
		var next_encounter_weight: int = next_node.encounter_weights[current_node.encounter.type]
		var adjusting_value: int = (int((current_encounter_weight + next_encounter_weight) / 2) - 16) - next_encounter_weight
		
		# campfire rules
		if current_node.encounter.type == Encounter.EncounterType.CAMPFIRE and 0 < MIN_NUM_LAYERS_BETWEEN_CAMPFIRES:
			adjusting_value = -100
		
		# battle rules
		if current_node.encounter.type == Encounter.EncounterType.BATTLE:
			for i in range(max(0, layer_index - 1), max(0, layer_index - MAX_NUM_CONSECUTIVE_BATTLES - 1), -1):
				if path.nodes[i].encounter.type != Encounter.EncounterType.BATTLE:
					break
				
				adjusting_value = -100
		
		# random encounter rules
		if current_node.encounter.type == Encounter.EncounterType.RANDOM:
			for i in range(max(0, layer_index - 1), max(0, layer_index - MAX_NUM_CONSECUTIVE_RANDOM_ENCOUNTERS - 1), -1):
				if path.nodes[i].encounter.type != Encounter.EncounterType.RANDOM:
					break
				
				adjusting_value = -100
		
		_adjust_encounter_weights(next_node, current_node.encounter.type, adjusting_value)

func _get_paths_containing_node(node: MapNode) -> Array[MapPath]:
	var result: Array[MapPath] = []
	
	for path: MapPath in paths:
		if path.nodes.has(node):
			result.append(path)
	
	return result

func _adjust_encounter_weights(node: MapNode, weight: Encounter.EncounterType, value: int) -> void:
	var current_weight: int = node.encounter_weights[weight]
	node.encounter_weights[weight] = max(0, current_weight + value)
	var ignored_encounters: int = 1
	
	for type in node.encounter_weights:
		if type == weight:
			continue
		
		if node.encounter_weights[type] <= 0:
			ignored_encounters += 1
			continue
		
		node.encounter_weights[type] += int(current_weight / (node.encounter_weights.size() - ignored_encounters))
	
	if current_weight % (node.encounter_weights.size() - 1) != 0:
		if weight != Encounter.EncounterType.BATTLE:
			node.encounter_weights[Encounter.EncounterType.BATTLE] += current_weight % (node.encounter_weights.size() - 1)
		else:
			node.encounter_weights[Encounter.EncounterType.RANDOM] += current_weight % (node.encounter_weights.size() - 1)
