extends CharacterBody2D

var speed = 40
@export var anim: AnimatedSprite2D
@onready var name_label: Label = $Label

@export var hand: Sprite2D
@export var item_resources: ItemData
@export var item_world_scene: PackedScene

var is_sitting = false
var equipped_tool: ItemData

func _ready() -> void:
	if Global.name_user != null and Global.name_user != "":
		name_label.text = Global.name_user
	else:
		name_label.text = "Без имени"

	if item_resources:
		Global.add_item(item_resources)

	if not Global.inventory_updated.is_connected(update_hand_visual):
		Global.inventory_updated.connect(update_hand_visual)

	update_hand_visual()

func _physics_process(_delta):
	var input = Vector2(
		Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'),
		Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
	)
	velocity = input.normalized() * speed

	if is_sitting:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if input.x > 0:
		anim.flip_h = true
	elif input.x < 0:
		anim.flip_h = false

	if input != Vector2.ZERO:
		anim.play('walk')
	else:
		anim.play('idle')

	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed('interact'):
		if is_sitting:
			is_sitting = false
			anim.play('idle')
		else:
			is_sitting = true
			anim.play('sit')

	if event.is_action_pressed("next_item"):
		change_selection(1)
	if event.is_action_pressed("prev_item"):
		change_selection(-1)

	if event.is_action_pressed("drop_item"):
		drop_item()

func change_selection(direction: int):
	if Global.inventory.size() == 0:
		return

	Global.active_slot_index = (Global.active_slot_index + direction) % Global.inventory.size()
	if Global.active_slot_index < 0:
		Global.active_slot_index = Global.inventory.size() - 1

	update_hand_visual()
	Global.update_selection_visual.emit()

func update_hand_visual():
	if Global.inventory.size() == 0:
		hand.texture = null
		equipped_tool = null
		return

	Global.active_slot_index = clamp(Global.active_slot_index, 0, Global.inventory.size() - 1)
	var item = Global.inventory[Global.active_slot_index]

	if item:
		hand.texture = item.icon
		equipped_tool = item if item.is_tool else null
	else:
		hand.texture = null
		equipped_tool = null

func drop_item():
	if Global.inventory.size() > 0:
		var item_to_drop = Global.inventory[Global.active_slot_index]
		
		# Создаем копию для выброса (1 штука)
		var drop_copy = item_to_drop.duplicate()
		drop_copy.amount = 1
		spawn_dropped_item(drop_copy)
		
		# Уменьшаем количество в инвентаре
		if item_to_drop.amount > 1:
			item_to_drop.amount -= 1
		else:
			Global.inventory.remove_at(Global.active_slot_index)
			
		Global.active_slot_index = clamp(Global.active_slot_index, 0, Global.inventory.size() - 1)
		Global.inventory_updated.emit() # <--- ОБРАТИ ВНИМАНИЕ: Global. В НАЧАЛЕ
		update_hand_visual()

func spawn_dropped_item(item_to_drop: ItemData):
	if item_world_scene != null:
		var new_item = item_world_scene.instantiate()
		new_item.item_resources = item_to_drop
		
		var random_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
		new_item.position = self.position + random_offset
		
		get_tree().current_scene.add_child(new_item)
