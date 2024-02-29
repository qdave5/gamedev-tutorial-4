extends Node2D

export (PackedScene) var obstacle
export (float) var intervalSpawn = 1

export (int) var minXSpawnRange = -1000
export (int) var maxXSpawnRange = 1000
export (int) var minYSpawnRange = -0
export (int) var maxYSpawnRange = 0

var countObstacle = 0

func _ready():
	repeat()

func spawn():
	var spawned = obstacle.instance()
	get_parent().add_child(spawned)

	var spawn_pos = global_position
	spawn_pos.x = spawn_pos.x + rand_range(minXSpawnRange, maxXSpawnRange)
	spawn_pos.y = spawn_pos.y + rand_range(minYSpawnRange, maxYSpawnRange)

	spawned.global_position = spawn_pos

func repeat():
	spawn()
	yield(get_tree().create_timer(intervalSpawn), "timeout")
	repeat()
