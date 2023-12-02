extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16

var target_velocity = Vector3.ZERO

signal hit
signal supercharged

func acquire_powerup(type):
	print("Powerup \"%s\" - acquired." % type)

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# Notice how we are working with the vector's x and z axes
		# In 3D, the XZ plane is the ground plane
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	velocity = target_velocity
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	move_and_slide()
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		if collision.get_collider() == null:
			continue
		
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# we check if we are hitting it from above
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()

