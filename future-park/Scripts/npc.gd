extends Area2D

@export var player_id = -2000000
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		$txt.show()
	else:
		$txt.hide()
