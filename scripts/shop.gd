@tool
extends Control

@onready var SearchBar = $CanvasLayer/Title/SearchBar
@onready var VBox = $CanvasLayer/ScrollContainer/VBoxContainer
@onready var Error_Message = $CanvasLayer/ScrollContainer/VBoxContainer/ErrorMessage

var Revolver_Sale : float = 90
var Sniper_Sale : float = 90
var Shotgun_Sale : float = 90

func _ready():
	Error_Message.visible = false
	randomize_searchbar_text()
	set_sales()
	
	var music = get_music()
	music.stream_paused = true



func randomize_searchbar_text():
	var rand = randi_range(0, 10)
	var text : String = " "
	
	if rand == 0:
		text = "boo basket fillers for women"
	elif rand == 1:
		text = "dog balls"
	elif rand == 2:
		text = "police hat"
	elif rand == 3:
		text = "peach x25 omega"
	elif rand == 4:
		text = "funny items for men"
	elif rand == 5:
		text = "mouth tape"
	elif rand == 6:
		text = "men clothes for men"
	elif rand == 7:
		text = "rude gifts"
	elif rand == 8:
		text = "fidget toys"
	elif rand == 9:
		text = "ladies sale"
	elif rand == 10:
		text = "solar lights"
	SearchBar.placeholder_text = text


func _on_search_button_pressed():
	randomize_searchbar_text()
	var search = SearchBar.text
	
	var children = VBox.get_children()
	
	if search == "" or search == " ":
		for i in children:
			i.visible = true
			Error_Message.visible = false
	else:
		var count = 0
		var total = 0
		for i in children:
			total = total + 1
			if str(i.name).to_lower() != str(search).to_lower():
				if i is Label:
					pass
				else:
					i.visible = false
				count = count + 1
			else:
				i.visible = true
			if count == total:
				Error_Message.visible = true
			else :
				Error_Message.visible = false

func set_sales():
	var children = VBox.get_children()
	for i in children:
		var childrener = i.get_children()
		for j in childrener:
			if str(j.name) == "Sale_Amount":
				var randnum = randf_range(90.00, 99.99)
				var Sale = snapped(randnum, 0.01)
				
				j.text = "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0][wave amp=50.0 freq=5.0 connected=1]" + str(Sale) +"% off !!!"


func _on_buy_medkit_pressed():
	var player = get_player()
	if player is playerCharacter:
		if player.money >= 30:
			player.Medkits = player.Medkits + 1
			player.money = player.money - 30

func get_player():
	var playerfound = false
	var root_children = get_tree().root.get_children()
	for i in root_children:
		if i is playerCharacter:
			return i
			playerfound = true
		var root_children_children = i.get_children() 
		for j in root_children_children:
			if j is playerCharacter:
				return j
				playerfound = true
		if playerfound == false:
			return "Error: Not found player"


func _on_buy_revolver_pressed():
	var player = get_player()
	if player.money >= 1:
		player._remove_debuffs()
		player.ammo_max = 6
		player.ammo = 6
		player.shoot_screen_shake_amount = 1
		player.base_damage = 1
		player.bullet_speed = 3
		player.reload_time = 2
		player.GunSprite.play("Revolver")
		_randomise_debuff()
		player.money = player.money - 1


func _on_buy_sniper_pressed():
	var player = get_player()
	if player.money >= 10:
		player._remove_debuffs()
		player.ammo_max = 1
		player.ammo = 1
		player.shoot_screen_shake_amount = 20
		player.reload_time = 4
		player.base_damage = 5
		player.bullet_speed = 10
		_randomise_debuff()
		player.GunSprite.play("Sniper")
		player.money = player.money - 10

func _randomise_debuff():
	var player = get_player()
	var rand = randi_range(0, 1)
	if rand == 0:
		player.Screen_Shake_Debuff = true
	elif rand == 1:
		player.bullet_reverse_debuff = true
	player._apply_debuffs()


func _on_exit_button_pressed():
	var player = get_player()
	player.shopping = false
	var music = get_music()
	music.stream_paused = false
	self.queue_free()

func get_music():
	var musicfound = false
	var root_children = get_tree().root.get_children()
	for i in root_children:
		if i.name == "LevelMusic":
			return i
			musicfound = true
		var root_children_children = i.get_children() 
		for j in root_children_children:
			if j.name == "LevelMusic":
				return j
				musicfound = true
		if musicfound == false:
			return "Error: Not found Music"
