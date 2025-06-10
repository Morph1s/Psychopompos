class_name MainMenu
extends Control

signal start_run_button_pressed
signal options_button_pressed
signal exit_button_pressed

@onready var start_run_particles = $Effects/StartRunParticles
@onready var options_particles = $Effects/OptionsParticles
@onready var exit_particles = $Effects/ExitParticles

func _on_start_run_button_up():
	start_run_button_pressed.emit()

func _on_options_button_up():
	options_button_pressed.emit()

func _on_exit_button_up():
	exit_button_pressed.emit()

func _on_start_run_mouse_entered():
	start_run_particles.emitting = true

func _on_start_run_mouse_exited():
	start_run_particles.emitting = false

func _on_options_mouse_entered():
	options_particles.emitting = true

func _on_options_mouse_exited():
	options_particles.emitting = false

func _on_exit_mouse_entered():
	exit_particles.emitting = true

func _on_exit_mouse_exited():
	exit_particles.emitting = false
