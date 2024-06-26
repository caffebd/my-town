extends KinematicBody


const WALK_SPEED:float = 10.0
const SPRINT_SPEED:float = 20.0


export var speed = 10
export var accel = 10
export var gravity = 50
export var jump = 15

var look_rotation: Vector3 = Vector3.ZERO
onready var head: Spatial = $"%Spatial"

var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO


var max_angle:float = 80.0
var min_angle:float = -80.0

export var sensitivity: float = 0.2

var captured: bool = true

var can_climb: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.connect("climbing", self, "_climbing")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	captured = true

func _climbing(state):
	velocity.y = 0
	can_climb = state


func _physics_process(delta):
		
	head.rotation_degrees.x = look_rotation.x
	rotation_degrees.y = look_rotation.y
	
	
	if can_climb:
		velocity.y = 0
		if Input.is_action_just_pressed("climb_up"):
			velocity.y = jump
		elif Input.is_action_just_pressed("climb_down"):
			velocity.y = -jump
		else:
			velocity.y -= gravity * delta
	
	
	if Input.is_action_pressed("run"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= 0.03 * delta
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump
	
	move_dir = Vector3(
		Input.get_axis("left", "right"),0,Input.get_axis("forward", "back")).normalized().rotated(Vector3.UP, rotation.y)
	
	velocity.x = lerp(velocity.x, move_dir.x * speed, accel * delta)
	velocity.z = lerp(velocity.z, move_dir.z * speed, accel * delta)
	
	velocity = move_and_slide(velocity, Vector3.UP)		
		

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if captured:
			captured = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			captured = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if not captured:
		return
	
	if event is InputEventMouseMotion:
		look_rotation.y -= event.relative.x * sensitivity
		look_rotation.x -= event.relative.y * sensitivity
		look_rotation.x = clamp(look_rotation.x, min_angle, max_angle)
		

	
