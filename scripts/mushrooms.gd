extends Node2D

@export var item_resources: ItemData

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player':
		Global.add_item(item_resources)
		queue_free()
