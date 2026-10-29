extends Node

signal item_collected(item_name: String)
signal inventory_updated
signal update_selection_visual

var name_user

func set_info(_name):
	name_user = _name

var active_slot_index: int = 0
@export var max_inventory_size: int = 4 # По заданию всего 4 слота
var max_stack_size: int = 15 # По заданию стаканье по 15

var inventory: Array[ItemData] = []

func add_item(item: ItemData):
	if item == null:
		return

	# PHASE_12: Стаканье до 15
	for current_item in inventory:
		if current_item.name == item.name:
			if current_item.amount < max_stack_size:
				current_item.amount += 1
				inventory_updated.emit()
				return
			else:
				print("Стак заполнен (15)! Нужен новый слот.")

	# PHASE_13: Лимит слотов (4)
	if inventory.size() < max_inventory_size:
		var new_item = item.duplicate() # Клонируем ресурс, чтобы не менять оригинал
		new_item.amount = 1
		inventory.append(new_item)
		inventory_updated.emit()
	else:
		print("ИНВЕНТАРЬ ПОЛОН! Максимум 4 слота.")
