extends Button

var item_data: ItemData

func setup(item: ItemData):
	item_data = item
	icon = item.icon
	expand_icon = true
