extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var info: Label = $info
@onready var portal1: Area2D = $"../portal1"


var active = false
var teleporting = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	info.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	touching_player(bodies)
	
	if Input.is_action_just_pressed("tele"):
		if player:
			player.teleporting = true
			var tween = create_tween()
			tween.parallel()
			tween.tween_property(player,"position",position,0.2)
			tween.tween_property(player,"modulate",Color(0.0, 0.508, 0.99),0.6)
			sprite.play("active")
			teleporting = true


func touching_player(bodies):
	if bodies.size() == 1 and not teleporting:
		sprite.play("detect")
		info.show()
		player = bodies[0]
	else:
		if not teleporting:
			sprite.play("idle")
			info.hide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if teleporting:
		player.position = portal1.position
		player.teleporting = false
		var tween = create_tween()
		tween.tween_property(player,"modulate",Color(1.0, 1.0, 1.0),0.6)
		teleporting = false
	player = null
