extends Node2D

signal connected

var url = "ws://localhost:8080"

@onready var oplrs: Node2D = $world/oplrs
@onready var main_player: CharacterBody2D = $world/oplrs/mainPlayer
@onready var item_list: ItemList = %ItemList

const o_player = preload("uid://ddg3nhpydul4i")

var connected_players = []


var socket = WebSocketPeer.new()

var has_connected = false

var player_id = null

func connect_to_server():
	var err = socket.connect_to_url(url)
	
	if err != OK:
		print("Connection error: ", err)
		
		
		
func _process(delta):
	socket.poll()
	
	var state = socket.get_ready_state()

	if state == WebSocketPeer.STATE_CONNECTING:
		print("Connecting......")
		
	elif state == WebSocketPeer.STATE_OPEN:
		if not has_connected:
			has_connected = true
			$CanvasLayer/load.hide()
			$CanvasLayer.hide()
			$world.show()
			$world/Camera/chat_layout.show()
			print("Connected")
			send_data( {"type": "new_player", "name": Global.usrname, "charIdx": Global.char})
			main_player.set_usrname(Global.usrname)
			main_player.charIdx = Global.char
		
		while socket.get_available_packet_count()>0:
			var packet = socket.get_packet()
			var data = packet.get_string_from_utf8()
			decode_data(JSON.parse_string(data))
		
		
func decode_data(data: Dictionary):
	if data["type"] == "welcome":
		player_id = data["id"]
		$world/oplrs/mainPlayer.player_id = data["id"]

		var plrs = data["players"]

		for player in plrs:
			var char = o_player.instantiate()
			oplrs.add_child(char)

			char.player_id = player["id"]
			char.set_usrname(player["name"])
			char.charIdx = int(player["charIdx"])
			char.position = Vector2(
				player["pos"]["x"],
				player["pos"]["y"]
			)
			connected_players.append(char)
			print(player["name"])
	
	
	if data["type"] == "pos":
		var pos = data["pos"]
		for child in oplrs.get_children():
			if int(child.player_id) == int(data["id"]): 
				child.position = Vector2(pos["x"], pos["y"])
				
	if data["type"] == "msg":
		for child in oplrs.get_children():
			if int(child.player_id) == int(data["id"]): 
				child.add_bubble(data["message"])
				var ntext = child.usrname + ": " + data["message"]
				item_list.add_item(ntext)
	
	if data["type"] == "gone_player":
		for child in oplrs.get_children():
			if int(child.player_id) == int(data["id"]): 
				child.queue_free()
	
	
	if data["type"] == "new_player":
		var char = o_player.instantiate()
		oplrs.add_child(char)
		
		char.player_id = data["id"]
		char.set_usrname(data["name"])
		char.charIdx = int(data["charIdx"])
		char.position = Vector2(
			data["pos"]["x"],
			data["pos"]["y"]
		)
		connected_players.append(char)
		print(data["name"])
		
	


func send_data(data):
	var message = JSON.stringify(data)
	socket.send_text(message)
