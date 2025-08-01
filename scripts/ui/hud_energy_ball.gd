class_name HudEnergyBall
extends Control

@onready var activated_ball: TextureRect = $ActiveBall
@onready var highlighted_ball: TextureRect = $HighlightedBall
@onready var primary_particles: CPUParticles2D = $PrimaryParticles
@onready var highlight_particles: CPUParticles2D = $HighlightParticles

var active: bool = true


func activate() -> void:
	if active:
		return
	
	active = true
	activated_ball.show()
	primary_particles.emitting = true

func spend_energy() -> void:
	if not active:
		return
	
	remove_highlight()
	
	active = false
	activated_ball.hide()
	primary_particles.emitting = false

func highlight() -> void:
	if not active:
		return
	
	highlighted_ball.show()
	if not highlight_particles.emitting:
		highlight_particles.emitting = true

func remove_highlight() -> void:
	highlighted_ball.hide()
	highlight_particles.emitting = false
