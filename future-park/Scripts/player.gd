extends CharacterBody2D


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var usrname:= "Rawwwr"
@export var charIdx = 1


const SPEED = 300.0


func _ready() -> void:
	var anim = "idle"+str(charIdx)
	sprite.play(anim)

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("chat"):
		pass

	var direction := Input.get_vector("left", "right","up","down")
	if direction:
		velocity = direction * SPEED
		
		sprite.play("walk"+str(charIdx))
		
		if direction.x > 0:
			var tween = create_tween()
			tween.tween_property(sprite,"scale",Vector2(5,5),0.1)
		elif direction.x < 0:
			var tween = create_tween()
			tween.tween_property(sprite,"scale",Vector2(-5,5),0.1)
	else:
		velocity = Vector2.ZERO
		sprite.play("idle"+str(charIdx))


	move_and_slide()
