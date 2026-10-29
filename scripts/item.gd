extends Node2D

@export var item_resources: ItemData
@export var sprite: Sprite2D

func _ready() -> void:
	if item_resources:
		sprite.texture = item_resources.icon

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player':
		Global.add_item(item_resources)
		queue_free()
