extends Control

@onready var sprite: AnimatedSprite2D = $MarginContainer/HBoxContainer/VBoxContainer/ColorRect/sprite
@onready var username: Label = $MarginContainer/HBoxContainer/VBoxContainer/ColorRect/username
@onready var usr_edit: LineEdit = $MarginContainer/HBoxContainer/VBoxContainer2/usr_edit
@onready var world: Node2D = $"../../world"
@onready var system: Node2D = $"../.."

var charIdx = 1

func _ready() -> void:
	username.text = Global.usrname
	usr_edit.text = Global.usrname
	sprite.play("idle"+str(Global.char))
	


func _on_prev_btn_pressed() -> void:
	charIdx = ((charIdx-2+4)%4)+1
	sprite.play("idle"+str(charIdx))
	Global.char = charIdx


func _on_next_btn_pressed() -> void:
	charIdx = (charIdx%4)+1
	sprite.play("idle"+str(charIdx))
	Global.char = charIdx



func _on_apply_btn_pressed() -> void:
	username.text = usr_edit.text
	Global.usrname = usr_edit.text



func _on_play_btn_pressed() -> void:
	system.connect_to_server()
	$"../load".show()
	Global.save_data()
