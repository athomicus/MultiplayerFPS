extends CharacterBody3D


const SPEED = 10
const JUMP_VELOCITY = 10
@onready var anim_player = $AnimationPlayer
@onready var camera = $Camera3D
@onready var muzzle = $Camera3D/Pistol/Muzzle
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 20.0
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED #lock the cursor
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x *.005) # rotate player when mouse
		camera.rotate_x(-event.relative.y *.005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2 )
	if Input.is_action_just_pressed("Shooting") \
		and anim_player.current_animation != "Shooting":
		play_shoot_effects()
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if anim_player.current_animation == "Shoot":
		pass
	elif input_dir != Vector2.ZERO and is_on_floor():
		anim_player.play("move")
	else:
		anim_player.play("idle")
		
		
	move_and_slide()

func play_shoot_effects():
	anim_player.stop()
	anim_player.play("shot")
	muzzle.restart()
	muzzle.emitting = true
	
	
