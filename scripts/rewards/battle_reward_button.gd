class_name BattleRewardButton
extends Button

signal reward_selected(type: BattleRewards.RewardType, amount: int, button: Button)

var type: BattleRewards.RewardType
var count: int
var artifact_reward: Artifact = null

func set_rewards(reward_type: BattleRewards.RewardType, amount: int) -> void:
	type = reward_type
	count = amount
	
	match type:
		BattleRewards.RewardType.CARDS:
			text = "CHOOSE CARD"
		BattleRewards.RewardType.COINS:
			text = str(count) + " COINS"
		BattleRewards.RewardType.ARTEFACT:
			artifact_reward = ArtifactHandler.get_random_artifact()
			if not artifact_reward:
				queue_free()
				return
			
			icon = artifact_reward.texture
			text = artifact_reward.name

func _on_button_up():
	reward_selected.emit(type, count, self)
