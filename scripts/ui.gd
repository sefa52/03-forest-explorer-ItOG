extends CanvasLayer

@export var label: Label

var item_count: int = 0

func _ready() -> void:
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

func _on_inventory_updated() -> void:
	item_count = 0
	for item in Global.inventory:
		if item.name == 'mushroom':
			item_count += item.amount
	label.text = str(item_count)
