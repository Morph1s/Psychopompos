class_name BattleRewardButton
extends Button

signal reward_selected(type: BattleRewards.RewardType, amount: int, button: Button)

const COINS_TOOLTIP: Array[TooltipData] = [preload("res://resources/tooltips/action_tooltips/coins_tooltip.tres")]
const SELECT_CARD_TOOLTIP: Array[TooltipData] = [preload("res://resources/tooltips/action_tooltips/select_card_tooltip.tres")]

@onready var tooltip = $Tooltip

var type: BattleRewards.RewardType
var count: int
var artifact_reward: Artifact = null

func set_rewards(reward_type: BattleRewards.RewardType, amount: int) -> void:
	if not is_node_ready():
		await ready
	
	type = reward_type
	count = amount
	
	match type:
		BattleRewards.RewardType.CARDS:
			text = "CHOOSE CARD"
			SELECT_CARD_TOOLTIP[0].set_description()
			tooltip.load_tooltips(SELECT_CARD_TOOLTIP)
		
		#BattleRewards.RewardType.COINS:
			#text = str(count) + " COINS"
			#COINS_TOOLTIP[0].set_description()
			#tooltip.load_tooltips(COINS_TOOLTIP)
		
		BattleRewards.RewardType.ARTIFACT:
			artifact_reward = ArtifactHandler.get_random_artifact()
			if not artifact_reward:
				queue_free()
				return
			
			text = artifact_reward.name
			
			for tooltip_entry in artifact_reward.tooltip:
				tooltip_entry.set_description()
			
			tooltip.load_tooltips(artifact_reward.tooltip)

func _on_button_up():
	reward_selected.emit(type, count, self)

func _on_mouse_entered():
	tooltip.show()

func _on_mouse_exited():
	tooltip.hide()
