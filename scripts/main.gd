extends Node

const RUN: PackedScene = preload("res://scenes/run.tscn")
const MAIN_MENU: PackedScene = preload("res://scenes/ui/main_menu.tscn")

@onready var pause_menu_layer = $PauseMenuLayer
@onready var close_game_confirmation = $CloseGameConfirmation
@onready var abandon_run_confirmation: CanvasLayer = $AbandonRunConfirmation



var loaded_scene: Node

## called on starting the game
func _ready() -> void:
	_load_main_menu_scene()
	abandon_run_confirmation.abandon_run_confirmed.connect( _return_to_main_menu)
	EventBusHandler.open_settings.connect(_open_settings)
	ArtifactHandler.initialize()

func _input(event) -> void:
	if not event.is_action_pressed("pause"):
		return
	
	_open_settings()

## switch to run (and close main menu)
func _load_run_scene() -> void:
	if loaded_scene:
		loaded_scene.queue_free()
		print("killed child")
	
	var run_scene_instance: Run = RUN.instantiate()
	
	loaded_scene = run_scene_instance
	add_child(run_scene_instance)
	run_scene_instance.load_main_menu.connect(_load_main_menu_scene)

## switch to main menu (and close run)
func _load_main_menu_scene() -> void:
	if loaded_scene:
		loaded_scene.queue_free()
		print("killed child")
	
	var main_menu_instance = MAIN_MENU.instantiate()
	main_menu_instance.start_run_button_pressed.connect(_load_run_scene)
	main_menu_instance.exit_button_pressed.connect(_request_closing_game)
	main_menu_instance.options_button_pressed.connect(_on_main_menu_options_button_pressed)
	
	loaded_scene = main_menu_instance
	add_child(main_menu_instance)

#region signal funcions
func _request_closing_game() -> void:
	close_game_confirmation.ask_for_exit_confirmation()

func _return_to_main_menu() -> void:
	abandon_run_confirmation.hide()
	_load_main_menu_scene()

func _on_pause_menu_layer_exit_button_pressed() -> void:
	_request_closing_game()

func _on_pause_menu_layer_main_menu_button_pressed() -> void:
	abandon_run_confirmation.ask_abandon_run_confirmation()

func _on_main_menu_options_button_pressed() -> void:
	pause_menu_layer.open(PauseMenu.OpenFrom.MAIN_MENU)

func _open_settings() -> void:
	if pause_menu_layer.visible:
		pause_menu_layer.close()
		return
	
	if loaded_scene is MainMenu:
		pause_menu_layer.open(PauseMenu.OpenFrom.MAIN_MENU)
	elif loaded_scene is Run:
		pause_menu_layer.open(PauseMenu.OpenFrom.RUN)

#endregion
