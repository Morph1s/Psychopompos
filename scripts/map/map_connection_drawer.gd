class_name MapConnectionDrawer
extends Control

var connections: Array[Dictionary] = []

func set_connections(encounter_to_button: Dictionary):
	connections.clear()
	
	for encounter: Encounter in encounter_to_button.keys():
		var button_from = encounter_to_button[encounter]
		for target in encounter.connections_to:
			if target in encounter_to_button:
				var button_to = encounter_to_button[target]
				connections.append({
					"from": button_from,
					"to": button_to,
				})
	queue_redraw()

func _draw():
	for conn in connections:
		var button_from = conn["from"]
		var button_to = conn["to"]
		
		if not button_from.visible or not button_to.visible:
			continue
		
		var pos_from = button_from.get_global_position() + (button_from.size * 0.5) - self.get_global_position()
		var pos_to = button_to.get_global_position() + (button_to.size * 0.5) - self.get_global_position()
		
		draw_line(pos_from, pos_to, Color.WHITE, 2.0)
