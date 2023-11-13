extends CharacterBody3D

var speed = 0.01

func _process(delta):
	if (position.y <= 1.5):
		position.y += 0.03
	
	position += ($"../Player".position-position).normalized() * speed
	
	look_at($"../Player".global_position)
	
	for body in $Area3D.get_overlapping_areas():
		var groups = body.get_groups()
		if ("knife" in groups):
			queue_free()
