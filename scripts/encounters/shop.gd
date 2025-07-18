class_name Shop
extends Node2D

signal shop_finished

@onready var leave_button: Button = $ShopLayer/ShopUI/ShopUIMargin/GridContainer/LeaveButton
@onready var packs_panel: CardPackPanel = $ShopLayer/ShopUI/ShopUIMargin/GridContainer/PacksPanel
@onready var trade_panel: TradePanel = $ShopLayer/ShopUI/ShopUIMargin/GridContainer/TradePanel
@onready var direct_buy_panel: DirectBuyPanel = $ShopLayer/ShopUI/ShopUIMargin/GridContainer/DirectBuyPanel


func initialize():
	packs_panel.initialize()
	trade_panel.initialize()
	direct_buy_panel.initialize()

func _on_leave_button_pressed() -> void:
	shop_finished.emit()
	EventBusHandler.shop_finished.emit()
