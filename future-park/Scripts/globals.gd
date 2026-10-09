extends Node

var save_path = "user://data.save"

var usrname:String = "Rawwr"
var char:int = 1

func save_data():
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	file.store_var(usrname)
	file.store_var(char)
	
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		usrname = file.get_var()
		char = file.get_var()

func _ready() -> void:
	load_data()
