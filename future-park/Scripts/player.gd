extends CharacterBody2D

@onready var NetManager = $"../../.."
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var usr_label: Label = $usrname
@export var usrname:= "Rawwwr"
@export var charIdx = 1
@export var teleporting:= false
@export var player_id:=0
@onready var item_list: ItemList = %ItemList

var adjust_text = false

var last_pos = position

const BUBBLE_TMP = preload("uid://tpmkiwq8btr0")

const SPEED = 300.0

func add_bubble(text):
	var bubl = BUBBLE_TMP.instantiate()
	bubl.text = text
	add_child(bubl)
	var ntext = usrname + ": " + text
	item_list.add_item(ntext)

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
		
	var direction := Input.get_vector("left", "right","up","down")
	if direction and not teleporting and not Global.is_typing:
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
		
	if last_pos != position:
		NetManager.send_data({
			"type":"pos",
			"id":str(player_id),
			"pos": {"x":position.x, "y":position.y}
		})
		
	last_pos = position


	move_and_slide()
