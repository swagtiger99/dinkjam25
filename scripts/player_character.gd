class_name playerCharacter extends CharacterBody2D


const SPEED = 300.0

var HP = 7
var ammo = 6
var bullet_scene = preload("res://scenes/bullet.tscn")
var reloading = false
var damaged = false
var inCutscene = false
var ending = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var Walk_Timer = $Timer
@onready var PlayerCam = $Camera2D
@onready var RevolverSprite = $GunPivot/Revolver

func playerDamaged(damageTaken):
	HP -= damageTaken
	
func shoot():
	
	if ammo != 0:
		var bullet = bullet_scene.instantiate()
		get_tree().get_root().add_child(bullet)
		
		bullet.rotation = get_node("GunPivot").rotation
		
		bullet.position.y = $GunPivot/Revolver.global_position.y
		bullet.position.x = $GunPivot/Revolver.global_position.x
		
		ammo -= 1
		reloading = false
		
	elif ammo == 0 and reloading == false:
		reload()
		
func reload():
	reloading = true
	ammo = 0
	await get_tree().create_timer(2).timeout
	ammo = 6
	 

func _physics_process(delta: float) -> void:

	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * SPEED
	
	if direction.x > 0:
		animated_sprite.flip_h = true
		animated_sprite.play("side")
	elif direction.x < 0:
		animated_sprite.flip_h = false
		animated_sprite.play("side")
	elif direction.y != 0:
		animated_sprite.play("vertical")
	if direction. x == 0 and direction.y == 0:
		animated_sprite.play("idle")
	if inCutscene == false or ending == true:
		move_and_slide()
		
	if Input.is_action_just_pressed("shoot") and ammo != 0:
		shoot()
	elif Input.is_action_just_pressed("reload") and ammo !=6:
		reload()
	
	if HP == 0:
		get_tree().reload_current_scene()

	move_and_slide()
