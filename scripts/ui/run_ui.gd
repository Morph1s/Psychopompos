class_name RunUI
extends TextureRect

signal open_map
signal open_deck_view

@onready var tooltip: Tooltip = $Tooltip
@onready var hitpoints: Label = $TopBarMargin/TopBarHBox/IconsLeft/HPLabel
@onready var coins: Label = $TopBarMargin/TopBarHBox/IconsLeft/CoinsLabel
@onready var artifact_container: HBoxContainer = $TopBarMargin/TopBarHBox/ArtifactMargin/ArtifactContainer


func initialize() -> void:
	RunData.player_stats.hitpoints_changed.connect(_on_stats_hp_changed)
	RunData.player_stats.coins_changed.connect(_on_stats_coins_changed)
	ArtifactHandler.artifact_selected.connect(_on_artifact_handler_artifact_selected)

func _on_deck_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		open_deck_view.emit()

func _on_map_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		open_map.emit()

func _on_settings_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		EventBusHandler.open_settings.emit()

func _on_stats_hp_changed(current_hp: int, max_hp: int) -> void:
	hitpoints.text = "%d/%d" % [current_hp, max_hp]

func _on_stats_coins_changed(current_coins: int) -> void:
	coins.text = str(current_coins)

func _on_artifact_handler_artifact_selected(artifact: Artifact) -> void:
	for tooltip_entry in artifact.tooltip:
		tooltip_entry.set_description()
	
	var artifact_visualization: TextureRect = TextureRect.new()
	
	# set parameters
	artifact_visualization.texture = artifact.texture
	artifact_visualization.stretch_mode = TextureRect.STRETCH_KEEP
	artifact_visualization.custom_minimum_size = Vector2(16, 16)
	
	# add to scene
	artifact_container.add_child(artifact_visualization)
	
	# connect signals
	artifact_visualization.mouse_entered.connect(func(): show_artifact_tooltip(artifact_visualization, artifact.tooltip))
	artifact_visualization.mouse_exited.connect(_on_tooltip_visualization_mouse_exited)

func show_artifact_tooltip(visualization: TextureRect, tooltip_data: Array[TooltipData]) -> void:
	tooltip.position = visualization.global_position + Vector2(17, 0)
	tooltip.load_tooltips(tooltip_data)
	tooltip.show()

func _on_tooltip_visualization_mouse_exited() -> void:
	tooltip.hide()
