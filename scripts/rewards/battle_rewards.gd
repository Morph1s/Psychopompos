class_name BattleRewards
extends Control

enum RewardType {
	CARDS,
	COINS,
	ARTIFACT,
}

@onready var rewards_container: VBoxContainer = $RewardSelection/CenterPanel/VerticalContainer/RewardsContainer
@onready var select_card_screen: SelectCardsScreen = $SelectCardScreen

const BATTLE_REWARD_BUTTON = preload("res://scenes/encounters/battle_reward_button.tscn")

const CARDS_PER_CARD_REWARD: int = 3
# common reward constants for balancing
const COMMON_COIN_CHANCE: float = 0.7
const COMMON_COIN_AMOUNT_MAX: int = 50
const COMMON_COIN_AMOUNT_MIN: int = 20
# boss reward constants for balancing
const BOSS_COIN_CHANCE: float = 1.0
const BOSS_COIN_AMOUNT_MAX: int = 70
const BOSS_COIN_AMOUNT_MIN: int = 50

var rng: RandomNumberGenerator = RunData.sub_rngs["rng_battle_rewards"]
var current_card_reward_button: Button
var card_rewards_list: Array[Array] = []
var reward_count: int = 0


func load_common_rewards() -> void:
	if not is_node_ready():
		await ready
	var card_reward: BattleRewardButton = BATTLE_REWARD_BUTTON.instantiate()
	card_reward.set_rewards(RewardType.CARDS, card_rewards_list.size())
	card_rewards_list.append(DeckHandler.get_card_selection(CARDS_PER_CARD_REWARD))
	card_reward.reward_selected.connect(_on_reward_button_reward_selected)
	rewards_container.add_child(card_reward)
	reward_count = 1
	
	if rng.randf_range(0, 1) < COMMON_COIN_CHANCE:
		var coin_reward: BattleRewardButton = BATTLE_REWARD_BUTTON.instantiate()
		coin_reward.set_rewards(RewardType.COINS, rng.randi_range(COMMON_COIN_AMOUNT_MIN, COMMON_COIN_AMOUNT_MAX))
		coin_reward.reward_selected.connect(_on_reward_button_reward_selected)
		rewards_container.add_child(coin_reward)
		reward_count += 1

func load_boss_rewards() -> void:
	if not is_node_ready():
		await ready
	var artifact_reward: BattleRewardButton = BATTLE_REWARD_BUTTON.instantiate()
	artifact_reward.set_rewards(RewardType.ARTIFACT, 0)
	artifact_reward.reward_selected.connect(_on_reward_button_reward_selected)
	rewards_container.add_child(artifact_reward)
	
	var god_cards_distribution: Dictionary[CardType.Rarity, int] = {
		CardType.Rarity.GODS_BOON: 100
	}
	
	var card_reward: BattleRewardButton = BATTLE_REWARD_BUTTON.instantiate()
	card_reward.set_rewards(RewardType.CARDS, card_rewards_list.size())
	card_rewards_list.append(DeckHandler.get_card_selection(CARDS_PER_CARD_REWARD, god_cards_distribution))
	card_reward.reward_selected.connect(_on_reward_button_reward_selected)
	rewards_container.add_child(card_reward)
	reward_count = 2
	
	if rng.randf_range(0, 1) < BOSS_COIN_CHANCE:
		var coin_reward: BattleRewardButton = BATTLE_REWARD_BUTTON.instantiate()
		coin_reward.set_rewards(RewardType.COINS, rng.randi_range(BOSS_COIN_AMOUNT_MIN, BOSS_COIN_AMOUNT_MAX))
		coin_reward.reward_selected.connect(_on_reward_button_reward_selected)
		rewards_container.add_child(coin_reward)
		reward_count += 1

func _on_reward_button_reward_selected(type: RewardType, count: int, button: BattleRewardButton) -> void:
	match type:
		RewardType.CARDS:
			select_card_screen.initialize(card_rewards_list[count], 1)
			select_card_screen.show()
			current_card_reward_button = button
		RewardType.COINS:
			RunData.player_stats.coins += count
			button.queue_free()
			_reward_selected()
		RewardType.ARTIFACT:
			ArtifactHandler.select_artifact(button.artifact_reward)
			button.queue_free()
			_reward_selected()

func _reward_selected() -> void:
	reward_count -= 1
	if reward_count <= 0:
		EventBusHandler.encounter_finished.emit()
		queue_free()

#region signal functions

func _on_skip_rewards_button_up() -> void:
	EventBusHandler.encounter_finished.emit()
	queue_free()

func _on_select_card_screen_cards_selected(cards: Array[CardType], card_visuals: Array[CardVisualization]) -> void:
	select_card_screen.hide()
	
	if cards.is_empty():
		return
	
	var positions: Array[Vector2] = []
	
	for card: CardType in cards:
		DeckHandler.add_card_to_deck(card)
		positions.append(card_visuals[cards.find(card)].global_position)
		print("Add card ", card.card_name, " to deck")
	
	EventBusHandler.card_picked_for_deck_add.emit(cards, positions)
	current_card_reward_button.queue_free()
	
	_reward_selected()

#endregion
