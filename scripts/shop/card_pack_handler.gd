class_name CardPackHandler
extends Node

var distributions: Dictionary[CardPack.PackRarity, Dictionary] = {
	CardPack.PackRarity.COMMON: {
		CardType.Rarity.COMMON_CARD: 80,
		CardType.Rarity.HERO_CARD: 18,
		CardType.Rarity.GODS_BOON: 2
	},
	CardPack.PackRarity.RARE: {
		CardType.Rarity.COMMON_CARD: 55,
		CardType.Rarity.HERO_CARD: 35,
		CardType.Rarity.GODS_BOON: 10
	},
	CardPack.PackRarity.LEGENDARY: {
		CardType.Rarity.COMMON_CARD: 15,
		CardType.Rarity.HERO_CARD: 40,
		CardType.Rarity.GODS_BOON: 45
	},
}

var rng: RandomNumberGenerator = RunData.sub_rngs["rng_card_pack_handler"]

const PACK_SIZE: int = 5

func create_pack(rarity: CardPack.PackRarity) -> CardPack:
	var pack := CardPack.new()
	pack.pack_rarity = rarity
	pack.price = _calculate_price(rarity)
	pack.cards = DeckHandler.get_card_selection(PACK_SIZE, distributions[rarity])
	var tooltip: TooltipData = TooltipData.new()
	# TODO: make tooltip dynamic
	tooltip.description = "Select 2 out of 5 random cards"
	pack.tooltips.append(tooltip)
	return pack

func _calculate_price(rarity: CardPack.PackRarity) -> int:
	return {
		CardPack.PackRarity.COMMON: rng.randi_range(50, 70),
		CardPack.PackRarity.RARE: rng.randi_range(80, 100),
		CardPack.PackRarity.LEGENDARY: rng.randi_range(120, 150)
	}[rarity]
