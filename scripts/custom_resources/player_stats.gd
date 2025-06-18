class_name PlayerStats
extends EntityStats

signal energy_changed(new_energy: int, maximum_energy: int)

@export var maximum_energy: int = 3:
	set(value):
		maximum_energy = value
		energy_changed.emit(current_energy, maximum_energy)

@export var current_energy: int = 0:
	set(value):
		current_energy = value
		energy_changed.emit(current_energy, maximum_energy)

@export var card_draw_amount: int = 5
@export var coins: int = 0

func lose_one_energy() -> void:
	current_energy -= 1
	if current_energy < 0 :
		lose_hp(current_energy*current_energy)
