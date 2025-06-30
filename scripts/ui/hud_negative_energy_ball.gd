class_name HudNegativeEnergyBall
extends TextureRect

@onready var constant_particles: CPUParticles2D = $ConstantParticles
@onready var particle_explosion: CPUParticles2D = $ParticleExplosion

var exploding: bool = false

func explode() -> void:
	exploding = true
	texture = null
	constant_particles.emitting = false
	particle_explosion.emitting = true
	await particle_explosion.finished
	queue_free()
