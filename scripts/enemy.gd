class_name Enemy extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
var health = 10

func _ready():
	var rand = randi_range(0, 4)
	
	sprite.play(str(rand))

func _physics_process(delta):
	if health >= 0:
		queue_free()


func _on_damage_area_body_entered(body):
	if body is playerCharacter:
		body.HP = body.HP - 1
