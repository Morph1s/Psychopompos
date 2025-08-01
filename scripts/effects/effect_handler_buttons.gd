extends Node2D

signal increment_pressed
signal decrement_pressed

@onready var increment_area: Area2D = $IncrementArea
@onready var decrement_area: Area2D = $DecrementArea
@onready var increment_sprite: Sprite2D = $IncrementArea/IncrementSprite
@onready var decrement_sprite: Sprite2D = $DecrementArea/DecrementSprite

const INCREMENT_SPRITE: Texture = preload("res://assets/graphics/hud/pictograms/small_arrow_down.png")
const INCREMENT_SPRITE_HIGHLIGHTED: Texture = preload("res://assets/graphics/hud/pictograms/small_arrow_down_highlighted.png")
const DECREMENT_SPRITE: Texture = preload("res://assets/graphics/hud/pictograms/small_arrow_up.png")
const DECREMENT_SPRITE_HIGHLIGHTED: Texture = preload("res://assets/graphics/hud/pictograms/small_arrow_up_highlighted.png")


func set_bottom_button_position(effects_bottom_boundary: int) -> void:
	increment_area.position = Vector2(4, effects_bottom_boundary + 3)

func set_increment_button_visibility(visibility: bool) -> void:
	if visibility:
		increment_area.show()
	else:
		increment_area.hide()

func set_decrement_button_visibility(visibility: bool) -> void:
	if visibility:
		decrement_area.show()
	else:
		decrement_area.hide()

func _on_increment_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_released("left_click"):
		increment_pressed.emit()

func _on_decrement_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_released("left_click"):
		decrement_pressed.emit()

func _on_increment_area_mouse_entered() -> void:
	increment_sprite.texture = INCREMENT_SPRITE_HIGHLIGHTED
	increment_sprite.position = Vector2(0, 1)

func _on_increment_area_mouse_exited() -> void:
	increment_sprite.texture = INCREMENT_SPRITE
	increment_sprite.position = Vector2(0, 0)

func _on_decrement_area_mouse_entered() -> void:
	decrement_sprite.texture = DECREMENT_SPRITE_HIGHLIGHTED
	decrement_sprite.position = Vector2(0, -1)

func _on_decrement_area_mouse_exited() -> void:
	decrement_sprite.texture = DECREMENT_SPRITE
	decrement_sprite.position = Vector2(0, 0)
