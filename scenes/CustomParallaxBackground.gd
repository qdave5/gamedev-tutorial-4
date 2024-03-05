extends ParallaxBackground


var texture_rect : TextureRect

export var rectSizeX : int = 1024
export var texture : Texture = load("res://assets/kenney_platformerpack/PNG/Backgrounds/colored_land.png")

export var rectScaleX : float = 1.5
export var rectScaleY : float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect  = get_node("ParallaxLayer/TextureRect")
	texture_rect.texture = texture
	texture_rect.rect_size.x = rectSizeX
	texture_rect.rect_scale.x = rectScaleX
	texture_rect.rect_scale.y = rectScaleY
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
