extends CharacterBody2D

@export var speed: int = 100
@onready var animations = $AnimationPlayer
@onready var walkUpSprite = $walkUp
@onready var walkDownSprite = $walkDown
@onready var walkRightSprite = $walkRight
@onready var walkLeftSprite = $walkLeft
@onready var idleSprite = $Idle
@onready var attackSprite = $Attack

@export var inventory: Inventory

var enemyInAttackRange = false
var enemyAttackCooldown = true 
var health = 100
var playerAlive = true
var direction = "Down"
var attacking: bool = false
var attackIP = false			 #Attack in progress

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed	
	if Input.is_physical_key_pressed(KEY_SPACE):
		attack()

func hideSprites():
	walkUpSprite.hide()
	walkDownSprite.hide()
	walkRightSprite.hide()
	walkLeftSprite.hide()
	idleSprite.hide()
	attackSprite.hide()

func attack():
	attacking = true
	if animations.get_current_animation() != ("attack" + direction):
		hideSprites()
		global.playerCurrentlyAttacking = true
		attackIP = true
		print("attack initiated")
		attackSprite.show()
		animations.play("attack" + direction)   
	
func updateAnimation(direction):
	if animations.get_current_animation() != ("attack" + direction):
		hideSprites()
	# var direction = "Down"
			
	if velocity.length() == 0 and !attacking:
		idleSprite.show()
		animations.play("idle" + direction)
	elif !attacking:
		if velocity.x > 0: 
			walkRightSprite.show()
			direction = "Right"
		elif velocity.x < 0: 
			walkLeftSprite.show()
			direction = "Left"
		elif velocity.y < 0: 
			walkUpSprite.show()
			direction = "Up"
		else:
			walkDownSprite.show()
			direction = "Down"
		animations.play("walk" + direction)
	
	return direction

func _physics_process(delta):
	enemyAttack()
	handleInput()
	updateHealth()
	
	if !attacking:
		move_and_slide()
	direction = updateAnimation(direction)
	
	if health <= 0:
		playerAlive = false
		health = 0
		print("player has been killed")
		self.queue_free()


func _on_animation_player_animation_finished(animation):
	if animation == ("attack" + direction):
		attacking = false

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemyInAttackRange = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemyInAttackRange = false

func enemyAttack():
	if enemyInAttackRange and enemyAttackCooldown == true:
		health = health - 20
		enemyAttackCooldown = false
		$AttackCooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemyAttackCooldown = true

func updateHealth():
	var healthBar = $HealthBar
	healthBar.value = health
	
	if health >= 100:
		healthBar.visible = false
	else:
		healthBar.visible = true

func _on_regen_timer_timeout():
	if health < 100 and !attacking:
		health = health + 20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0
	
