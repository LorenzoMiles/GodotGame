extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")

func _physics_process(_delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * _delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h=true
	else:
		get_node("AnimatedSprite2D").flip_h=false
	if direction:
		velocity.x = direction * SPEED
		if velocity.y==0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y==0:
			anim.play("idle")
		if velocity.y > 0:
			anim.play("Fall")
	move_and_slide()
func die() -> void:
	get_tree().reload_current_scene()
