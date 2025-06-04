class_name PlayerHud
extends EntityHud

var current_energy: int = 3
var max_energy: int = 3
var max_energy_deficit: int = -3

@onready var energy_bar: TextureProgressBar = $EnergyBar
@onready var energy_label_current: Label = $EnergyLabelCurrent

func _ready() -> void:
	_update_display()

func set_current_energy(value: int) -> void:
	current_energy = value
	_update_display()

func set_max_energy(value: int) -> void:
	max_energy = value
	_update_display()

func set_max_energy_deficit(value: int) -> void:
	max_energy_deficit = value
	_update_display()

func _update_display() -> void:
	super._update_display()
	print("Value: %d" % [current_energy])
	energy_bar.value = current_energy
	energy_bar.max_value = max_energy
	energy_bar.min_value = -max_energy_deficit
