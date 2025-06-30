class_name MapConnectionDrawer
extends Control

var connections: Array[Dictionary] = []

# creates a Dictionary for each connection line that contains the buttons that should be connected
func set_connections(node_to_button: Dictionary[MapNode, Button]):
	connections.clear()
	
	for node: MapNode in node_to_button.keys():
		var button_from = node_to_button[node]				# pos 1
		for target in node.next_nodes:
			if target in node_to_button:
				var button_to = node_to_button[target]		# pos 2
				connections.append({
					"from": button_from,
					"to": button_to,
				})
	# initial drawing of the connection lines
	queue_redraw()

func _draw():
	for conn in connections:
		var button_from = conn["from"]
		var button_to = conn["to"]
		
		# calculate the starting and end points of the line
		var pos_from = button_from.get_global_position() + (button_from.size * 0.5) - self.get_global_position()
		var pos_to = button_to.get_global_position() + (button_to.size * 0.5) - self.get_global_position()
		
		draw_line(pos_from, pos_to, Color.WHITE, 2.0)
