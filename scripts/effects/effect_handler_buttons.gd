extends Node2D

signal increment_pressed
signal decrement_pressed

const INCREMENT_SPRITE = preload("res://assets/graphics/ui/hud_pictograms/small_arrow_down.png")
const INCREMENT_SPRITE_HIGHLIGHTED = preload("res://assets/graphics/ui/hud_pictograms/small_arrow_down_highlighted.png")
const DECREMENT_SPRITE = preload("res://assets/graphics/ui/hud_pictograms/small_arrow_up.png")
const DECREMENT_SPRITE_HIGHLIGHTED = preload("res://assets/graphics/ui/hud_pictograms/small_arrow_up_highlighted.png")

@onready var increment_area = $IncrementArea
@onready var decrement_area = $DecrementArea
@onready var increment_sprite = $IncrementArea/IncrementSprite
@onready var decrement_sprite = $DecrementArea/DecrementSprite

#var increment_sprite_position: Vector2 = Vector2(0, 0)
#var increment_sprite_position_highlighted: Vector2 = Vector2(0, 0)
#var decrement_sprite_position: Vector2 = Vector2(0, 0)
#var decrement_sprite_position_highlighted: Vector2 = Vector2(0, 0)


func set_bottom_button_position(effects_bottom_boundary: int) -> void:
	increment_area.position = Vector2(4, effects_bottom_boundary + 3)

func set_increment_button_visibility(visible: bool) -> void:
	if visible:
		increment_area.show()
	else:
		increment_area.hide()

func set_decrement_button_visibility(visible: bool) -> void:
	if visible:
		decrement_area.show()
	else:
		decrement_area.hide()

func _on_increment_area_input_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_released("left_click"):
		increment_pressed.emit()

func _on_decrement_area_input_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action_released("left_click"):
		decrement_pressed.emit()

func _on_increment_area_mouse_entered():
	increment_sprite.texture = INCREMENT_SPRITE_HIGHLIGHTED
	increment_sprite.position = Vector2(0, 1)

func _on_increment_area_mouse_exited():
	increment_sprite.texture = INCREMENT_SPRITE
	increment_sprite.position = Vector2(0, 0)

func _on_decrement_area_mouse_entered():
	decrement_sprite.texture = DECREMENT_SPRITE_HIGHLIGHTED
	decrement_sprite.position = Vector2(0, -1)

func _on_decrement_area_mouse_exited():
	decrement_sprite.texture = DECREMENT_SPRITE
	decrement_sprite.position = Vector2(0, 0)
