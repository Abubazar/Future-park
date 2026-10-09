extends Control

@onready var sprite: AnimatedSprite2D = $MarginContainer/HBoxContainer/VBoxContainer/ColorRect/sprite
@onready var username: Label = $MarginContainer/HBoxContainer/VBoxContainer/ColorRect/username
@onready var prev_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/prev_btn
@onready var next_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/next_btn
@onready var usr_edit: LineEdit = $MarginContainer/HBoxContainer/VBoxContainer2/usr_edit
@onready var apply_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer2/apply_btn
@onready var play_btn: Button = $MarginContainer/HBoxContainer/VBoxContainer2/play_btn

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
	#hide()
	Global.save_data()
