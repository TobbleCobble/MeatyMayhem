extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


func _on_timer_timeout():
	var ghoul = preload("res://ghoul.tscn").instantiate()
	var ang = RandomNumberGenerator.new().randf_range(0, 2*PI)
	
	ghoul.position = $"../Player".global_position + Vector3(
		20*sin(ang), -1, 
		20*cos(ang)
	)
	
	get_parent().add_child(ghoul)
	
	$Timer.start()
