extends Button

signal reward_selected(type: BattleRewards.RewardType, amount: int, button: Button)

var type: BattleRewards.RewardType
var count: int

func set_rewards(reward_type: BattleRewards.RewardType, amount: int) -> void:
	type = reward_type
	count = amount
	
	match type:
		BattleRewards.RewardType.CARDS:
			text = "CHOOSE CARD"
		BattleRewards.RewardType.COINS:
			text = str(count) + " COINS"
		BattleRewards.RewardType.ARTEFACT:
			text = "ARTEFACT"


func _on_button_up():
	reward_selected.emit(type, count, self)
