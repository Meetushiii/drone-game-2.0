extends CharacterBody2D

const SPEED = 100.0
const JUMP_FORCE = -300.0
const GRAVITY = 900.0
const MAX_JUMPS = 2

var jumps_done = 0

func _physics_process(delta):
	apply_gravity(delta)
	handle_jumping()
	player_movement()
	
	move_and_slide()

	if is_on_floor():
		jumps_done = 0

func apply_gravity(delta):
	velocity.y += GRAVITY * delta

func handle_jumping():
	if Input.is_action_just_pressed("jump") and jumps_done < MAX_JUMPS:
		velocity.y = JUMP_FORCE
		jumps_done += 1

func player_movement():
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	else:
		velocity.x = 0
