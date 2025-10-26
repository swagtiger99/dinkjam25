class_name bullet extends Area2D

@onready var sprite = $AnimatedSprite2D

var damage = 1
var speed = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += Vector2(speed,0).rotated(rotation)


func _on_body_entered(body):
	if body is Enemy:
		body.health = body.health - damage
		queue_free()

func _change_sprite(animation : String):
	$AnimatedSprite2D.play(animation)
