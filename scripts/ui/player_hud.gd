class_name PlayerHud
extends EntityHud

var current_energy: int = 3
var max_energy: int = 3

@onready var energy_label: Label = $EnergyLabel

func _ready() -> void:
	_update_display()

func set_current_energy(value: int) -> void:
	current_energy = value
	_update_display()

func set_max_energy(value: int) -> void:
	max_energy = value
	_update_display()

func _update_display() -> void:
	super._update_display()
	energy_label.text = "Energy: %d/%d" % [current_energy, max_energy]
