extends KinematicBody2D
class_name Player


const MAX_SPEED = 1000
const ACCELEARTION = 4000
const FRICTION = 7000


var state
var health: int = 100
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var direction = Vector2.RIGHT

onready var frame = 0
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var player = $PlayerCollision
onready var health_set = $Health
onready var weaponHitbox = $HitboxPivot/WeaponHitbox
onready var healthSprite = $AnimatedSprite

func _ready():
	health_set.connect("no_health", self, "queue_free")
	weaponHitbox.knockback_vector = direction
	animationTree.active = true


func _physics_process(delta):

	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		direction = input_vector
		weaponHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELEARTION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
	
	if Input.is_action_just_pressed("attack"):
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Attack")
	
	velocity = move_and_slide(velocity)


func handle_hit():
	health_set.health -= 1
	if frame <= 10:
		frame += 1
	healthSprite.set_frame(frame)
	if health_set.health == 0:
		get_tree().change_scene("res://src/scenes/Game Over.tscn")


func _on_Hurtbox_area_entered(area):
	handle_hit()
