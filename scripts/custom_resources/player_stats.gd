class_name PlayerStats
extends EntityStats

signal energy_changed(new_energy: int, maximum_energy: int, maximum_energy_deficit)

@export var maximum_energy: int = 3:
	set(value):
		var old_maximum_energy = maximum_energy
		maximum_energy = value
		_check_energy_limits()
		
		if old_maximum_energy != maximum_energy:
			energy_changed.emit(current_energy, maximum_energy, maximum_energy_deficit)

@export var maximum_energy_deficit: int = 3:
	set(value):
		var old_maximum_energy_deficit = maximum_energy_deficit
		maximum_energy_deficit = value
		_check_energy_limits()
		
		if old_maximum_energy_deficit != maximum_energy_deficit:
			energy_changed.emit(current_energy, maximum_energy, maximum_energy_deficit)

var current_energy: int = 0:
	set(value):
		var old_energy = current_energy
		current_energy = clamp(value,-maximum_energy_deficit, maximum_energy)
		print("Trying to change current Energy")
		if old_energy != current_energy:
			energy_changed.emit(current_energy, maximum_energy, maximum_energy_deficit)

# To limit current energy if it's e.g bigger than max_energy or smaller than deficit
func _check_energy_limits() -> void:
	current_energy = clamp(current_energy, -maximum_energy_deficit, maximum_energy)
