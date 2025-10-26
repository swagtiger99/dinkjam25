class_name playerCharacter extends CharacterBody2D


const SPEED = 300.0

var money = 30

var Shop_Scene = preload("res://scenes/Shop.tscn")
var max_HP = 7
var HP = 7
var ammo = 6
var ammo_max = 6
var bullet_scene = preload("res://scenes/bullet.tscn")
var reloading = false
var damaged = false
var inCutscene = false
var ending = false
var Medkits = 0
var base_damage = 1
var damage_multiplier = 1
var bullet_speed = 3
var reload_time : float = 2

var shoot_screen_shake_amount: float = 1
var damage_screen_shake_amount : float = 10

@onready var animated_sprite = $AnimatedSprite2D
@onready var Walk_Timer = $Timer
@onready var PlayerCam = $Camera2D
@onready var GunSprite = $GunPivot/Revolver
@onready var Camera = $Camera2D
@onready var HPBar = $UI/CanvasLayer/HPBar
@onready var Ammo_Counter = $UI/CanvasLayer/Ammo_Counter
@onready var enemy = preload("res://scenes/Enemy.tscn")
@onready var Money_Count = $UI/CanvasLayer/Money_count

var shopping = false

#debuff list
var Screen_Shake_Debuff = false
var bullet_reverse_debuff = false

func _ready():
	GunSprite.play("Revolver")
	
	_remove_debuffs()
	_apply_debuffs()
	
	ammo = ammo_max
	HP = max_HP
	HPBar.max_value = max_HP
	HPBar.value = max_HP

func playerDamaged(damageTaken):
	HP -= damageTaken
	screen_shake(damage_screen_shake_amount)
	
func shoot():
	
	if ammo != 0 and shopping == false:
		screen_shake(shoot_screen_shake_amount)
		var Bullet = bullet_scene.instantiate()
		var cur_anim = str(GunSprite.animation)
		print(cur_anim)
		Bullet._change_sprite(cur_anim)
		get_tree().get_root().add_child(Bullet)
		
		Bullet.rotation = get_node("GunPivot").rotation
		
		Bullet.position.y = $GunPivot/Revolver.global_position.y
		Bullet.position.x = $GunPivot/Revolver.global_position.x
		
		Bullet.speed = bullet_speed
		
		ammo -= 1
		reloading = false
		
	if ammo == 0 and reloading == false:
		reload()
func reload():
	reloading = true
	ammo = 0
	await get_tree().create_timer(reload_time).timeout
	ammo = ammo_max
	reloading = false
	 

func _physics_process(delta: float) -> void:
	
	Money_Count.text = "Money: "+str(money) + "
	Medkits: "+str(Medkits)
	
	if reloading == false:
		Ammo_Counter.text = str(ammo)
	else:
		Ammo_Counter.text = "Reloading"
	
	HPBar.value = HP
	
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
	
	if Input.is_action_just_pressed("Phone") and shopping == false:
		shopping = true
		var new_shop = Shop_Scene.instantiate()
		get_tree().get_root().add_child(new_shop)
	
	if Input.is_action_just_pressed("Heal") and Medkits > 0:
		Medkits = Medkits - 1
		HP = HP - 1
	
	if HP == 0:
		for i in get_tree().root.get_children():
			if i.name != "Game":
				i.queue_free()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	if shopping == false:
		move_and_slide()

func damage_algorithm():
	base_damage * damage_multiplier

func screen_shake(intensity : float):
	var camera_tween = get_tree().create_tween()
	camera_tween.tween_method(Camera.StartCameraShake,intensity,1.0,0.5)

func _apply_debuffs():
	if Screen_Shake_Debuff == true:
		shoot_screen_shake_amount = shoot_screen_shake_amount * 20
		damage_screen_shake_amount = 500
	if bullet_reverse_debuff == true:
		if bullet_speed > 0:
			bullet_speed = bullet_speed * - 1

func _remove_debuffs():
	if Screen_Shake_Debuff == false:
		shoot_screen_shake_amount = 1
		damage_screen_shake_amount = 10
	if bullet_reverse_debuff == true:
		if bullet_speed < 0:
			bullet_speed = bullet_speed * - 1


func _on_enemy_timer_timeout():
	var new_enemy = enemy.instantiate()
	get_tree().get_root().add_child(new_enemy)
	
	var rand = randi_range(1, 6)
	var children = Camera.get_children()
	for i in children:
		if i.name == str(rand):
			new_enemy.global_position = i.global_position
