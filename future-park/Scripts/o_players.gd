extends CharacterBody2D


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var usr_label: Label = $usrname
@export var usrname:= "Rawwwr"
@export var charIdx = 1
@export var teleporting:= false
@export var player_id = 0

var last_pos = position

var adjust_text = false

const BUBBLE_TMP = preload("uid://tpmkiwq8btr0")

const SPEED = 300.0

func add_bubble(text):
	var bubl = BUBBLE_TMP.instantiate()
	bubl.text = text
	add_child(bubl)

func set_usrname(nam):
	usr_label.text = nam
	usr_label.position.x = -usr_label.size.x/2
	usrname = nam
	

func _ready() -> void:
	var anim = "idle"+str(charIdx)
	sprite.play(anim)
	usr_label.text = usrname

func _physics_process(delta: float) -> void:

	if not adjust_text:
		adjust_text
		usr_label.position.x = -usr_label.size.x/2
	
	var direction = position-last_pos
	direction = direction.clamp(Vector2(-1, -1), Vector2(1, 1))
	if direction and not teleporting and not Global.is_typing:
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
	last_pos=position


	move_and_slide()
