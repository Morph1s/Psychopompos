class_name PlayerStats
extends EntityStats

signal energy_changed(new_energy: int, maximum_energy: int)

@export var maximum_energy: int = 3:
	set(value):
		maximum_energy = value
		#_check_energy_limits()
		print("Trying to change maximum Energy. value: ", maximum_energy)
		energy_changed.emit(current_energy, maximum_energy)

#@export var maximum_energy_deficit: int = 3:
	#set(value):
		#var old_maximum_energy_deficit = maximum_energy_deficit
		#maximum_energy_deficit = value
		#_check_energy_limits()
		#
		#if old_maximum_energy_deficit != maximum_energy_deficit:
			#energy_changed.emit(current_energy, maximum_energy, maximum_energy_deficit)

@export var current_energy: int = 0:
	set(value):
		current_energy = value
		#current_energy = clamp(current_energy,-99,maximum_energy)
		print("Trying to change current Energy. Value: ", current_energy)
		energy_changed.emit(current_energy, maximum_energy)

func lose_one_energy()->void:
	print("current energy before energy lost: ", current_energy)
	current_energy -= 1
	if current_energy < 0 :
		lose_hp(current_energy*current_energy)
	print("current energy after energy lost: ", current_energy)


# To limit current energy if it's e.g bigger than max_energy or smaller than deficit
#func _check_energy_limits() -> void:
	#current_energy = clamp(current_energy, -99, maximum_energy)
