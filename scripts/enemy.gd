class_name Enemy extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
var health = 3

@onready var NavAgent = $NavigationAgent2D

const speed = 280

var player

var player_near = false

func _ready():
	var rand = randi_range(0, 4)
	
	sprite.play(str(rand))
	
	player = get_player()

func _physics_process(delta):
	if health <= 0:
		queue_free()
		player.money = player.money + 1
	if player != null:
		NavAgent.target_position = player.global_position
		velocity = global_position.direction_to(NavAgent.get_next_path_position()) * speed
		if player.shopping == false:
			move_and_slide()


func _on_damage_area_body_entered(body):
	if body is playerCharacter:
		player_near = true

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


func _on_damage_area_body_exited(body):
	if body is playerCharacter:
		player_near = false


func _on_timer_timeout():
	if player_near == true and player.shopping == false:
		player.HP = player.HP - 1
