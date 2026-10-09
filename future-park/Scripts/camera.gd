extends Camera2D

@export var target: Node = null
@export var speed:float = 5.0


func _process(delta: float) -> void:
	if target == null: return
	
	var new_position: Vector2 = target.global_position
	
	global_position = lerp(global_position, new_position, speed*delta)
