extends CanvasLayer

@export var grid: GridContainer

func _ready():
	Global.inventory_updated.connect(refresh_ui)
	Global.update_selection_visual.connect(update_selection_visual)
	refresh_ui()

func refresh_ui():
	# Очистка старых слотов
	for child in grid.get_children(): 
		child.queue_free()
	
	# Создание новых на основе данных из Global
	for item in Global.inventory:
		var slot = Button.new()
		slot.icon = item.icon
		slot.expand_icon = true
		slot.custom_minimum_size = Vector2(64, 64) # Размер ячейки
		
	
		if grid.has_theme_stylebox("normal"):
			slot.add_theme_stylebox_override("normal", grid.get_theme_stylebox("normal"))
		if grid.has_theme_stylebox("focus"):
			slot.add_theme_stylebox_override("focus", grid.get_theme_stylebox("focus"))
			
	
		if item.amount > 1: 
			var count_label = Label.new()
			count_label.text = str(item.amount)
			
			# Настраиваем шрифт и цвет
			count_label.add_theme_color_override("font_color", Color.WHITE)
			count_label.add_theme_color_override("font_shadow_color", Color.BLACK)
			count_label.add_theme_constant_override("shadow_offset_x", 1)
			count_label.add_theme_constant_override("shadow_offset_y", 1)
			count_label.add_theme_font_size_override("font_size", 16)
			
			# Прикрепляем текст к правому нижнему углу
			count_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
			count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			count_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
			
		
			count_label.position = Vector2(-25, -22) 
			
			slot.add_child(count_label) 
	
			
		grid.add_child(slot)
		
	update_selection_visual()

func update_selection_visual():
	var slots = grid.get_children()
	for i in range(slots.size()):
		if i == Global.active_slot_index:
			slots[i].grab_focus()
		else:
			slots[i].release_focus()
