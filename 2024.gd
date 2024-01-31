extends Control
@onready var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player = $text_animation
	animation_player.connect("animation_finished", _on_text_animation_animation_finished)
	animation_player.play("pop_up")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_animation_animation_finished(anim_name):
	if anim_name == "pop_up":
		animation_player.play("loop")
