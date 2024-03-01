extends ParallaxBackground


var texture_rect : TextureRect

export var rectSizeX : int = 1024
export var texture : Texture = load("res://assets/kenney_platformerpack/PNG/Backgrounds/colored_land.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect  = get_node("ParallaxLayer/TextureRect")
	texture_rect.texture = texture
	texture_rect.rect_size.x = rectSizeX
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
