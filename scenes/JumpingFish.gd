extends RigidBody2D

export var sceneName : String = "LoseScreen"

export var maxHeight : int = -300
export var linearVelocityY : int = -5

var isFall : bool = false

func _process(_delta):
	update_animation()
	if not isFall and position.y > maxHeight:
		linear_velocity.y += linearVelocityY
	elif isFall and position.y >= 0:
		self.queue_free()
	else:
		isFall = true

func update_animation():
	if linear_velocity.y <= 0:
		get_node("Sprite").frame_coords.y = 4
	else:
		get_node("Sprite").frame_coords.y = 2


func _on_JumpingFish_body_entered(body):
	print(body)
	if body.get_name() == "Player":
		get_tree().change_scene(str("res://scenes/" + sceneName + ".tscn"))
