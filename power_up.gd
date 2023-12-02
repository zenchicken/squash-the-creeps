extends Node3D

signal powerup_acquired(type)

func _on_powerup_detector_body_entered(body):
	powerup_acquired.emit("coin")
	queue_free()
