class_name PlayerHud
extends EntityHud

var current_energy: int = 2
var max_energy: int = 4
var max_energy_deficit = -1

func set_current_energy(value: int) -> void:
	current_energy = value
	
func set_max_energy(value: int) -> void:
	max_energy = value
	
func set_max_energy_deficit(value: int) -> void:
	max_energy_deficit = value
	
