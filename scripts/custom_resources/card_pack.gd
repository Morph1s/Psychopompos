class_name CardPack
extends Resource

enum PackRarity {
	COMMON,
	RARE,
	LEGENDARY
}

const SIZE: int = 5

var pack_rarity: PackRarity = PackRarity.COMMON
var price: int = 0
var cards: Array[CardType] = []
var tooltips: Array[TooltipData]
