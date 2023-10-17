extends CharacterBody2D

@export var speed: int = 35
@onready var animations = $AnimationPlayer
@onready var walkUpSprite = $walkUp
@onready var walkDownSprite = $walkDown
@onready var walkRightSprite = $walkRight
@onready var walkLeftSprite = $walkLeft
@onready var idleSprite = $Idle
@onready var attackSprite = $Attack

var direction = "Down"
var attacking: bool = false

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed	
	if Input.is_physical_key_pressed(KEY_SPACE):
		print("Attacking")
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
	handleInput()
	if !attacking:
		move_and_slide()
	direction = updateAnimation(direction)


func _on_animation_player_animation_finished(animation):
	if animation == ("attack" + direction):
		attacking = false
