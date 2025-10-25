class_name enemyBullet extends Area2D

func _process(delta):
	self.position += Vector2(3,0).rotated(rotation)
	

func _on_body_entered(body):
	if (body is playerCharacter):
		body.playerDamaged(1)
