extends CharacterBody2D

var speed: int = 150
var player_chase = false
var player = null

var health = 100
var playerInAttackZone = false
var canTakeDamage = false

func _ready():
	$AnimatedSprite2D.play("idle")


func _physics_process(delta):
	enemyTakeDamage()
	updateHealth()
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else :
			$AnimatedSprite2D.flip_h = false
			

func _on_detection_area_body_entered(body):
	player = body
	$AnimatedSprite2D.play("walk")
	player_chase = true 


func _on_detection_area_body_exited(body):
	player = null
	$AnimatedSprite2D.play("idle")
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_chase = false
		playerInAttackZone = true
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("attack")
		canTakeDamage = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_chase = true
		playerInAttackZone = false
		$AnimatedSprite2D.play("walk")
		canTakeDamage = false
		
func enemyTakeDamage():
	if playerInAttackZone and global.playerCurrentlyAttacking == true:
		if canTakeDamage == true:
			health = health - 20
			$TakeDamageCooldown.start()
			canTakeDamage = false
			print ("enemy health = ", health)
			enemyDeath()
			

func _on_take_damage_cooldown_timeout():
	canTakeDamage = true
	
func updateHealth():
	var enemyHealthBar = $EnemyHealthBar
	
	enemyHealthBar.value = health
	
	if health >= 100:
		enemyHealthBar.visible = false
	else:
		enemyHealthBar.visible = true

func enemyDeath():
	if health <= 0:
		health = 0
		playerInAttackZone = false
		player_chase = false
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play("death")
		$DeathAnimTimer.start()
		if $DeathAnimTimer.is_stopped():
			self.queue_free()


