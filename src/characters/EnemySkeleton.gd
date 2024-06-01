extends KinematicBody2D

export var ACCELERATION = 4000
export var MAX_SPEED = 1100
export var FRICTION = 7000

onready var player = null
onready var player2 = null
onready var despawnTimer = $Despawn
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var enemy = $SkeletonCollision
onready var direction = Vector2.RIGHT
onready var direction_to_player = Vector2.ZERO
onready var knockback = Vector2.ZERO
onready var velocity = Vector2.ZERO
onready var state = SPAWNING
onready var attackCD = $AttackCD

enum {
	SPAWNING
	ALIVE
	ATTACK
	HURT
	DEAD
	DESPAWN
}


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 2000 * delta)
	knockback = move_and_slide(knockback)
	match state:
		SPAWNING:
			animationTree.set("parameters/Spawn/blend_position", direction)
			animationState.travel("Spawn")
			if despawnTimer.time_left == 0:
				despawnTimer.start()
		ALIVE:
			animationTree.set("parameters/Walk/blend_position", direction)
			animationState.travel("Walk")
			if player != null:
				direction_to_player = position.direction_to(player.global_position)
			velocity = velocity.move_toward(direction_to_player * MAX_SPEED, ACCELERATION * delta)
		ATTACK:
			animationTree.set("parameters/Attack/blend_position", direction)
			animationState.travel("Attack")
			if despawnTimer.time_left == 0:
				despawnTimer.start()
		HURT:
			animationTree.set("parameters/Hurt/blend_position", direction)
			animationState.travel("Hurt")
			state = DEAD
		DEAD:
			animationTree.set("parameters/Death/blend_position", direction)
			animationState.travel("Death")
			if despawnTimer.time_left == 0:
				despawnTimer.start()
		DESPAWN:
			Global.score += 1
			queue_free()
		_:
			print ("Exception in states found")
	
	velocity = move_and_slide(velocity)
	


func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * 1200
	state = HURT


func _on_Despawn_timeout():
	if state == DEAD:
		Global.score += 1
		queue_free()
	elif state == HURT:
		state == DEAD
	elif state == SPAWNING:
		state = ALIVE
	elif state == ATTACK:
		state = ALIVE



func _on_PlayerDetection_body_entered(body):
	player = body


func _on_AttackCD_timeout():
	if state != DEAD:
		state = ATTACK


func _on_AttackRadius_area_entered(area):
	velocity = Vector2.ZERO
	if attackCD.time_left == 0:
		attackCD.start()

