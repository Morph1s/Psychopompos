class_name PlayerStats
extends EntityStats

signal energy_changed(new_energy: int, maximum_energy: int)

@export var starting_card_draw_amount: int = 5
@export var maximum_energy: int = 3:
	set(value):
		maximum_energy = value
		energy_changed.emit(current_energy, maximum_energy)

@export var current_energy: int = 0:
	set(value):
		current_energy = value
		energy_changed.emit(current_energy, maximum_energy)

var card_draw_amount: int = 5
@export var coins: int = 0

func initialize() -> void:
	super.initialize()
	card_draw_amount = starting_card_draw_amount

func pay_energy(amount: int) -> void:
	current_energy -= amount
	if current_energy < 0:
			lose_hp(hp_loss_from_energy_calculation(clamp(-current_energy, 0, amount)))

func hp_loss_from_energy_calculation(energy_overpayed: int) -> int:
	return 5 * energy_overpayed
