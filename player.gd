extends RigidBody3D

# Mouse look settings
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

# Node references
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

func _ready() -> void:
	# Start with mouse visible and uncaptured
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
	# Movement input
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	# Apply movement relative to twist pivot direction
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)

	# ESC to release mouse
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Custom capture mouse action: "ui_acceptt"
	elif Input.is_action_just_pressed("ui_acceptt"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Rotate camera
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)

	# Clamp pitch to avoid flipping
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		deg_to_rad(-30),
		deg_to_rad(30)
	)

	# Reset input values every frame (no accumulation)
	twist_input = 0.0
	pitch_input = 0.0

func _unhandled_input(event: InputEvent) -> void:
	# Only process mouse motion if captured
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist_input = -event.relative.x * mouse_sensitivity
		pitch_input = -event.relative.y * mouse_sensitivity

func _exit_tree() -> void:
	# Important for Mac: ensure mouse mode resets on quit
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
