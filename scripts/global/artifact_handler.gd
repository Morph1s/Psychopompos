extends Node

signal artifact_selected(artifact: Artifact)

var rng: RandomNumberGenerator = RunData.sub_rngs["rng_artifact"]

var available_artifacts: Array[Artifact] = []
var selected_artifacts: Array[Artifact] = []

var effect_names: Dictionary = {
	EffectAction.EffectType.AGILE: "Agile",
	EffectAction.EffectType.DAMOKLES_SWORD: "DamoklesSword",
	EffectAction.EffectType.GATHER: "Gather",
	EffectAction.EffectType.INCAPACITATED: "Incapacitated",
	EffectAction.EffectType.PHALANX: "Phalanx",
	EffectAction.EffectType.REGENERATION: "Regeneration",
	EffectAction.EffectType.VIGILANT: "Vigilant",
	EffectAction.EffectType.WARRIORS_FURRY: "WarriorsFury",
	EffectAction.EffectType.WOUNDED: "Wounded",
	EffectAction.EffectType.BLESSING: "Blessing",
	EffectAction.EffectType.ARTEMIS: "Artemis",
	EffectAction.EffectType.HELM_OF_HADES: "HelmOfHades",
	EffectAction.EffectType.INVINCIBLE: "Invincible",
	EffectAction.EffectType.LISTENING: "Listening",
	EffectAction.EffectType.NEMEAN_HIDE: "NemeanHide",
}


func initialize() -> void:
	EventBusHandler.battle_started.connect(_on_event_bus_battle_started)

func start_of_run_setup() -> void:
	available_artifacts = [
		load("res://resources/artifacts/ambrosia.tres"),
		load("res://resources/artifacts/bottle_of_icor.tres"),
		load("res://resources/artifacts/hermes_winged_boots.tres"),
		load("res://resources/artifacts/nectar.tres"),
		load("res://resources/artifacts/twig_of_lethe.tres"),
		load("res://resources/artifacts/helm_of_hades.tres"),
		load("res://resources/artifacts/lyre_of_orpheus.tres"),
		load("res://resources/artifacts/nemean_hide.tres"),
	]
	selected_artifacts = []

func get_random_artifact() -> Artifact:
	if available_artifacts.is_empty():
		return null
	return available_artifacts[rng.randi_range(0, available_artifacts.size() - 1)]

func select_artifact(artifact: Artifact) -> void:
	selected_artifacts.append(artifact)
	available_artifacts.erase(artifact)
	
	artifact_selected.emit(artifact)
	
	if artifact.pickup_active:
		artifact.pickup()
	
	if artifact.changes_active:
		match artifact.changed_value:
			0: # none
				pass
			1: # campfire heal
				RunData.altered_values[RunData.AlteredValue.CAMPFIRE_HEAL] += artifact.amount

func _on_event_bus_battle_started() -> void:
	for artifact in selected_artifacts:
		if artifact.effects_active:
			match artifact.target_type:
				TargetedAction.TargetType.PLAYER:
					var player_effect_handler: EffectHandler = get_tree().get_first_node_in_group("player").effect_handler
					player_effect_handler.apply_effect(effect_names[artifact.effect], artifact.amount)
				TargetedAction.TargetType.ENEMY_ALL_INCLUSIVE:
					for enemy: Enemy in get_tree().get_nodes_in_group("enemy"):
						var enemy_effect_handler: EffectHandler = enemy.effect_handler
						enemy_effect_handler.apply_effect(effect_names[artifact.effect], artifact.amount)

func _on_player_start_turn() -> void:
	var player_effect_handler: EffectHandler = get_tree().get_first_node_in_group("player").effect_handler
	for artifact in selected_artifacts:
		if artifact.start_of_turn_effects_active:
			player_effect_handler.apply_effect(effect_names[artifact.start_of_turn_effect], artifact.amount)
