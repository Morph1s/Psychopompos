class_name MainMenu
extends Control

signal start_run_button_pressed
signal options_button_pressed
signal exit_button_pressed

@onready var start_run_particles: CPUParticles2D = $Effects/StartRunParticles
@onready var options_particles: CPUParticles2D = $Effects/OptionsParticles
@onready var exit_particles: CPUParticles2D = $Effects/ExitParticles


func _on_start_run_button_up() -> void:
	start_run_button_pressed.emit()

func _on_options_button_up() -> void:
	options_button_pressed.emit()

func _on_exit_button_up() -> void:
	exit_button_pressed.emit()

func _on_start_run_mouse_entered() -> void:
	start_run_particles.emitting = true

func _on_start_run_mouse_exited() -> void:
	start_run_particles.emitting = false

func _on_options_mouse_entered() -> void:
	options_particles.emitting = true

func _on_options_mouse_exited() -> void:
	options_particles.emitting = false

func _on_exit_mouse_entered() -> void:
	exit_particles.emitting = true

func _on_exit_mouse_exited() -> void:
	exit_particles.emitting = false
