@tool
extends Control

@onready var SearchBar = $CanvasLayer/Title/SearchBar
@onready var VBox = $CanvasLayer/ScrollContainer/VBoxContainer
@onready var Error_Message = $CanvasLayer/ScrollContainer/VBoxContainer/ErrorMessage

func _ready():
	Error_Message.visible = false
	randomize_searchbar_text()



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
				i.visible = false
				count = count + 1
			else:
				i.visible = true
			if count == total:
				Error_Message.visible = true
			else :
				Error_Message.visible = false
