extends Sprite2D


@onready var pivot_node = $".."
const rotation_speed = 500.0

func _physics_process(delta):
	pivot_node.look_at(get_global_mouse_position())
	var revolver_rotation = pivot_node.rotation
	
	if pivot_node.rotation_degrees > 360:
		pivot_node.rotation_degrees = 0
	elif pivot_node.rotation_degrees < -360:
		pivot_node.rotation_degrees = 0
	
	if pivot_node.rotation_degrees <= -90 and pivot_node.rotation_degrees >= -270 or pivot_node.rotation_degrees >= 90 and pivot_node.rotation_degrees <= 270 :
		self.flip_v = true
	else:
		self.flip_v = false
