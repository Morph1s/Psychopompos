class_name MapGenerator
extends Node

const MAX_NUM_NODES_PER_LAYER = 6
const NUM_LAYERS_BEFORE_MINI_BOSS = 4		# excluding starting layer
const NUM_LAYERS_AFTER_MINI_BOSS = 5
const NUM_GENERATED_PATHS = 6				# CANNOT BE SMALLER THAN 2! - number of iterations of the path generation

var rng = RandomNumberGenerator.new()
var map: Array[MapLayer] = []
var paths: Array[MapPath] = []

### NEW ALGORITHM ###
func generate_map() -> Array[MapLayer]:
	#rng.seed = 26082002
	build_map_layers()
	generate_map_paths()
	hide_excluded_nodes()
	place_encounters()
	return map

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

func generate_map_paths():
	_generate_first_path()
	_generate_second_path()
	
	for path in NUM_GENERATED_PATHS - 2:
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
			previous_index = rng.randi_range(0, MAX_NUM_NODES_PER_LAYER / 2)
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
	var layer_index: int = 0
	
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
			layer_index += 1
			continue
		
		# for mini boss layer, choose the only encounter in layer.nodes
		if layer.type == MapLayer.MapLayerType.MINI_BOSS:
			var node: MapNode = layer.nodes[0]
			path.nodes.append(node)
			previous_index = rng.randi_range((MAX_NUM_NODES_PER_LAYER / 2) + 1, MAX_NUM_NODES_PER_LAYER - 1)
			layer_index += 1
			continue
		
		var min_index: int = max(_get_min_index_for_second_path(map.find(layer)), previous_index - 1)
		var max_index: int = min(previous_index + 1, MAX_NUM_NODES_PER_LAYER - 1)
		
		var node: MapNode = layer.nodes[rng.randi_range(min_index, max_index)]
		path.nodes.append(node)
		previous_index = layer.nodes.find(node)
		
		layer_index += 1
	
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
	var layer_index: int
	
	for layer: MapLayer in map:
		# when reaching the boss layer, break
		if layer.type == MapLayer.MapLayerType.BOSS:
			var node: MapNode = layer.nodes[0]
			path.nodes.append(node)
			break
		
		# for starting layer just choose a random node
		if layer.type == MapLayer.MapLayerType.START:
			var nodes: Array[MapNode] = layer.nodes.duplicate()
			var node: MapNode = nodes[rng.randi_range(0, nodes.size() - 1)]
			path.nodes.append(node)
			previous_index = layer.nodes.find(node)
			continue
		
		# for mini boss layer, choose the only encounter in layer.nodes
		if layer.type == MapLayer.MapLayerType.MINI_BOSS:
			var node: MapNode = layer.nodes[0]
			path.nodes.append(node)
			previous_index = rng.randi_range(0, MAX_NUM_NODES_PER_LAYER - 1)
			continue
		
		var min_index: int = max(_get_min_node_index(map.find(layer), previous_index), previous_index - 1)
		var max_index: int = min(previous_index + 1, _get_max_node_index(map.find(layer), previous_index))
		
		var node: MapNode = layer.nodes[rng.randi_range(min_index, max_index)]
		path.nodes.append(node)
		previous_index = layer.nodes.find(node)
	
	paths.append(path)
	_add_connections_from_path(path)

func _get_nodes_in_path_in_layer(layer_index: int) -> Array[MapNode]:
	var result: Array[MapNode] = []
	
	for path: MapPath in paths:
		if not result.has(path.nodes[layer_index]):
			result.append(path.nodes[layer_index])
	
	return result

func _get_min_node_index(layer_index: int, current_node_index: int) -> int:
	var last_layer: MapLayer = map.get(layer_index - 1)
	var current_layer: MapLayer = map.get(layer_index)
	var nodes_in_path_in_last_layer: Array[MapNode] = _get_nodes_in_path_in_layer(layer_index - 1)
	var next_smaller_node_in_a_path: MapNode
	var min_index: int = 0
	
	for node: MapNode in nodes_in_path_in_last_layer:
		if last_layer.nodes.find(node) < current_node_index + 1:
			if (next_smaller_node_in_a_path != null) and (last_layer.nodes.find(node) < last_layer.nodes.find(next_smaller_node_in_a_path)):
				continue
			next_smaller_node_in_a_path = node
	
	if next_smaller_node_in_a_path != null:
		for node: MapNode in next_smaller_node_in_a_path.next_nodes:
			if current_layer.nodes.find(node) > min_index:
				min_index = current_layer.nodes.find(node)
	
	return min_index

func _get_max_node_index(layer_index: int, current_node_index: int) -> int:
	var last_layer: MapLayer = map.get(layer_index - 1)
	var current_layer: MapLayer = map.get(layer_index)
	var nodes_in_path_in_last_layer: Array[MapNode] = _get_nodes_in_path_in_layer(layer_index - 1)
	var next_bigger_node_in_a_path: MapNode
	var max_index: int = MAX_NUM_NODES_PER_LAYER - 1
	
	for node: MapNode in nodes_in_path_in_last_layer:
		if last_layer.nodes.find(node) > current_node_index:
			if (next_bigger_node_in_a_path != null) and (last_layer.nodes.find(node) > last_layer.nodes.find(next_bigger_node_in_a_path)):
				continue
			next_bigger_node_in_a_path = node
	
	if next_bigger_node_in_a_path != null:
		for node: MapNode in next_bigger_node_in_a_path.next_nodes:
			if current_layer.nodes.find(node) < max_index:
				max_index = current_layer.nodes.find(node)
	
	return max_index

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

func place_encounters():
	_place_mini_boss_encounter()
	_place_boss_encounter()
	_place_random_encounters()

func _place_mini_boss_encounter():
	map[NUM_LAYERS_BEFORE_MINI_BOSS + 1].nodes[0].encounter = MiniBossEncounter.new()

func _place_boss_encounter():
	map.back().nodes[0].encounter = BossEncounter.new()

func _place_random_encounters():
	var encounter_types: Array = [
		BattleEncounter,
		CampfireEncounter,
	]
	# this needs to contain the same amount of items as encounter_types
	var encounter_weights: Array[int] = [
		80,
		20,
	]
	for layer: MapLayer in map:
		# mini boss and boss encounters are set in separate functions
		if layer.type == MapLayer.MapLayerType.MINI_BOSS or layer.type == MapLayer.MapLayerType.BOSS:
			continue
		
		# start layer only contains battles
		if layer.type == MapLayer.MapLayerType.START:
			for node: MapNode in layer.nodes:
				node.encounter = BattleEncounter.new()
			continue
		
		for node: MapNode in layer.nodes:
			var encounter_type = _choose_weighted_encounter(encounter_types, encounter_weights)
			node.encounter = encounter_type.new()

func _choose_weighted_encounter(encounters: Array, weights: Array[int]):
	var cum_weights: Array[int] = weights.duplicate()
	
	for w in cum_weights.size():
		if 0 < w:
			cum_weights[w] += cum_weights[w - 1]
	
	var random_index: int = rng.randi_range(0, cum_weights.back())
	
	for w in cum_weights:
		if w >= random_index:
			return encounters[cum_weights.find(w)]
