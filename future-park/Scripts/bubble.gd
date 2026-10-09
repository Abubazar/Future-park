extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = -size.x/2
	$Timer.wait_time+=int(text.length()/20)
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$".".queue_free()
