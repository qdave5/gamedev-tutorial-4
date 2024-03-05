extends Area2D

onready var texture_rect : TextureRect = get_parent().get_node("ParallaxBackground/ParallaxLayer/TextureRect")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ChangeBackgroundArea_body_entered(body):
	if body.get_name() == "Player":
		texture_rect.texture = load("res://assets/kenney_platformerpack/PNG/Backgrounds/colored_shroom.png")
