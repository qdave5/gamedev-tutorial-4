extends RigidBody2D


export var sceneName = "LoseScreen"
export var isQueueFree = false

onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	animation_player.play("pop")
	pass


func _on_PopUpFish_body_entered(body):
	if body.get_name() == "Player":
		get_tree().change_scene(str("res://scenes/" + sceneName + ".tscn"))
