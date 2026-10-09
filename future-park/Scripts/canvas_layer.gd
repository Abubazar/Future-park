extends CanvasLayer

@onready var line_edit: LineEdit = $LineEdit

@onready var NetManager: Node2D = $"../../.."


func send_chat(text):
	line_edit.text = ""
	$"../../oplrs/mainPlayer".add_bubble(text)
	NetManager.send_data({
		"type":"msg",
		"id": NetManager.player_id,
		"message":text
	})


func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("chat"):
		line_edit.grab_focus()


func _on_line_edit_text_submitted(new_text: String) -> void:
	if line_edit.text != "":
		send_chat(line_edit.text)


func _on_button_pressed() -> void:
	if line_edit.text != "":
		send_chat(line_edit.text)

func _on_line_edit_editing_toggled(toggled_on: bool) -> void:
	Global.is_typing = toggled_on
