extends Node2D

func _process(delta: float) -> void:
	var children = get_children()
	children.sort_custom(func(a, b): return a.global_position.y < b.global_position.y)

	for i in range(children.size()):
		children[i].z_index = i
