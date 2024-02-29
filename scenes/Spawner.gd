extends Node2D

export (PackedScene) var obstacle
export (int) var maxObstacle = 100
export (float) var intervalSpawn = 1

var countObstacle = 0

func _ready():
	repeat()

func spawn():
	var spawned = obstacle.instance()
	get_parent().add_child(spawned)

	var spawn_pos = global_position
	spawn_pos.x = spawn_pos.x + rand_range(-1000, 1000)

	spawned.global_position = spawn_pos

func repeat():
	if countObstacle < maxObstacle:
		spawn()
		countObstacle += 1
	yield(get_tree().create_timer(intervalSpawn), "timeout")
	repeat()
