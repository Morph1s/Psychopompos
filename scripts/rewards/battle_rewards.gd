class_name BattleRewards
extends Control

signal finished_selecting

const CARDS_PER_CARD_REWARD: int = 3
# common reward constants for balancing
const COMMON_COIN_CHANCE: float = 0.5
const COMMON_COIN_AMOUNT_MAX: int = 50
const COMMON_COIN_AMOUNT_MIN: int = 20
# rare reward constants for balancing
const RARE_COIN_CHANCE: float = 0.7
const RARE_COIN_AMOUNT_MAX: int = 70
const RARE_COIN_AMOUNT_MIN: int = 50

enum RewardType {
	CARDS,
	COINS,
	ARTEFACT,
}

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var current_card_reward_button: Button
var card_rewards_list: Array[Array] = []

@onready var rewards_container = $RewardSelection/CenterPanel/VerticalContainer/RewardsContainer
@onready var select_card_screen = $SelectCardScreen
@onready var reward_selection = $RewardSelection

const BATTLE_REWARD_BUTTON = preload("res://scenes/encounters/battle_reward_button.tscn")


func load_common_rewards() -> void:
	if not is_node_ready():
		await ready
	var card_reward = BATTLE_REWARD_BUTTON.instantiate()
	card_reward.set_rewards(RewardType.CARDS, card_rewards_list.size())
	card_rewards_list.append(DeckHandler.get_cards_for_card_rewards(CARDS_PER_CARD_REWARD))
	card_reward.reward_selected.connect(_on_reward_button_reward_selected)
	rewards_container.add_child(card_reward)
	
	if rng.randf_range(0, 1) < COMMON_COIN_CHANCE:
		var coin_reward = BATTLE_REWARD_BUTTON.instantiate()
		coin_reward.set_rewards(RewardType.COINS, rng.randi_range(COMMON_COIN_AMOUNT_MIN, COMMON_COIN_AMOUNT_MAX))
		coin_reward.reward_selected.connect(_on_reward_button_reward_selected)
		rewards_container.add_child(coin_reward)

func load_rare_rewards() -> void:
	if not is_node_ready():
		await ready
	var artefact_reward = BATTLE_REWARD_BUTTON.instantiate()
	artefact_reward.set_rewards(RewardType.ARTEFACT, 0)
	artefact_reward.reward_selected.connect(_on_reward_button_reward_selected)
	rewards_container.add_child(artefact_reward)
	
	var card_reward = BATTLE_REWARD_BUTTON.instantiate()
	card_reward.set_rewards(RewardType.CARDS, card_rewards_list.size())
	card_rewards_list.append(DeckHandler.get_cards_for_card_rewards(CARDS_PER_CARD_REWARD))
	card_reward.reward_selected.connect(_on_reward_button_reward_selected)
	rewards_container.add_child(card_reward)
	
	if rng.randf_range(0, 1) < RARE_COIN_CHANCE:
		var coin_reward = BATTLE_REWARD_BUTTON.instantiate()
		coin_reward.set_rewards(RewardType.COINS, rng.randi_range(RARE_COIN_AMOUNT_MIN, RARE_COIN_AMOUNT_MAX))
		coin_reward.reward_selected.connect(_on_reward_button_reward_selected)
		rewards_container.add_child(coin_reward)


func _on_reward_button_reward_selected(type: RewardType, count: int, button: Button) -> void:
	match type:
		RewardType.CARDS:
			select_card_screen.initialize(card_rewards_list[count])
			select_card_screen.show()
			current_card_reward_button = button
		RewardType.COINS:
			print("selected ", count, " coins (not implemented)")
			button.queue_free()
		RewardType.ARTEFACT:
			print("selected artefact (not implemented)")
			button.queue_free()

func _on_skip_rewards_button_up() -> void:
	print("skipped rewards")
	finished_selecting.emit()
	queue_free()

func _on_select_card_screen_card_selected(card: CardType) -> void:
	select_card_screen.hide()
	if card:
		DeckHandler.add_card_to_deck(card)
		print("add card to deck")
		current_card_reward_button.queue_free()

func _on_rewards_container_child_exiting_tree(_node):
	# this has to check for the child count being one instead of 0 
	# because the last child has not left the scene tree at the point of calling this signal
	if rewards_container.get_child_count() == 1:
		print("all rewards selected")
		finished_selecting.emit()
		queue_free()
