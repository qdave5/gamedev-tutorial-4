extends RigidBody2D

export var sceneName = "LoseScreen"


func _on_FallingFish_body_entered(body):
	if body.get_name() == "Player":
		get_tree().change_scene(str("res://scenes/" + sceneName + ".tscn"))
	else:
		get_node("Sprite").frame_coords.y = 3
		yield(get_tree().create_timer(3), "timeout")
		self.queue_free()
