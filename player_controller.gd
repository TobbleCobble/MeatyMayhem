extends CharacterBody3D


const speed = 5.0
const jump_power = 4.5

var health = 100
var attacked = false

var mouse_sensitivity = 0.001

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	print(velocity)
	if health == 0:
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_power

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		slash()

	var input_dir = Input.get_vector("left", "right", "forwards", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if(!$AnimationPlayer.is_playing()):
		$Pivot/knife/Area3D/CollisionShape3D.disabled = true
	
	for body in $GhoulCollider.get_overlapping_areas():
		var groups = body.get_groups()
		print(groups)
		if ("monster" in groups and attacked == false):
			health -= 10
			attacked = true
			$Timer.start()
	
	$'../CanvasLayer/Label'.text = str(health)
	
	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)

func slash():
	if(!$AnimationPlayer.is_playing()):
		$AnimationPlayer.play("slash")
		$Pivot/knife/Area3D/CollisionShape3D.disabled = false
	


func _on_timer_timeout():
	attacked = false
	pass # Replace with function body.
