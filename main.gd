extends Node

@export var mob_scene: PackedScene

# Notes (todo):
# - https://docs.godotengine.org/en/stable/getting_started/first_3d_game/07.killing_player.html

func _ready():
	$UserInterface/Retry.hide()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()


func _on_power_up_powerup_acquired(type):
	$Player.acquire_powerup(type)
