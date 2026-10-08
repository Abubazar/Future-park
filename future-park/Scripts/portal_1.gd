extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var info: Label = $info

var active = false
var teleporting = false
var player
var color = Color(1.0, 1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	touching_player(bodies)
	
	if Input.is_action_just_pressed("tele"):
		if player:
			teleporting = true
			var tween = create_tween()
			tween.tween_property(player,"modulate",Color(0.0, 0.508, 0.99),0.2)
			sprite.play("active")


func touching_player(bodies):
		if bodies.size() == 1 and not teleporting:
			sprite.play("detect")
			info.show()
			player = bodies[0]
		else:
			sprite.play("idle")
			info.hide()
			player = null
