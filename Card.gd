extends Button
var title : String = "Default Title"
var image : Texture = preload("res://assets/background_images/color.jpg")
var description : String = "Default Description"

# Called when the node enters the scene tree for the first time.
func _ready():
	update_card()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_card():
	$Name.text = title
	$Background.texture = image
