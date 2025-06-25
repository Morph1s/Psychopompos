class_name MapNode
extends Resource

var encounter: Encounter = null		# the encounter of this node
var active: bool = true				# whether or not the node is shown on the map
var next_nodes: Array[MapNode]		# connected nodes from the next layer
