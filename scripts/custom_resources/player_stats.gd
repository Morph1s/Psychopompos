class_name PlayerStats
extends EntityStats

@export var maximum_energy: int = 3:
	set(value):
		maximum_energy = value
		# call stats changed eventbus
@export var maximum_energy_deficit: int = 3:
	set(value):
		maximum_energy_deficit = value
		# call stats changed eventbus

var current_energy: int = maximum_energy
