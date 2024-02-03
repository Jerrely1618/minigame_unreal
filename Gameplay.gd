extends Node2D

const CARD = preload("res://Card.tscn")
const HAND_WIDTH = 10.0
@export var spread_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve

var aCardSelected = false
var animationInProgress = false
var politicians_data = []
var selected_card = null
func _ready():
	load_politicians_data()
	create_deck()

func load_politicians_data():
	var file = FileAccess.open("res://politicians.json", FileAccess.READ)
	var json_object = JSON.new()
	var error = json_object.parse(file.get_as_text())
	if error == OK:
		var content = json_object.get_data()
		file.close()
		if content is Array:
			politicians_data = content
		print(typeof(politicians_data))
	else:
		print("Failed to pare JSON", error)
func create_deck():
	var deck_node = $deck 
	for politician in politicians_data:
		var card = CARD.instantiate()
		card.get_node("Name").text = politician["Name"]
		card.get_node("Front_bckg").texture = load(politician["BackgroundImage"])
		card.get_node("Back_bckg").texture = load(politician["BackgroundImage"])
		card.get_node("PContainer/Profile").texture = load(politician["Profile"])
		card.get_node("Health/number").text = str(politician["Health"])
		card.get_node("Stamina/number").text = str(politician["Stamina"])
		card.get_node("Desc").text = politician["Desc"]
		card.get_node("Party").text = politician["Party"]
		card.get_node("Back_bckg/Back_info").text = politician["Info_Text"]
		deck_node.add_child(card)
		var info_node = card.get_node("Info")
		info_node.connect("pressed", Callable(_on_info_pressed).bind(card))
		card.connect("pressed", Callable(_on_card_pressed).bind(card))
		
		var animation_player = card.get_node("AnimationPlayer")
		animation_player.connect("animation_finished", _on_animation_finished)
	_position_cards()
	
func _position_cards():
	var deck_node = $deck 
	for card in deck_node.get_children():
		var deck_node_ratio = 0.5

		if deck_node.get_child_count() > 1:
			deck_node_ratio = float(card.get_index()) / float(deck_node.get_child_count() - 1)

		var destination = deck_node.position
		destination.x += spread_curve.sample(deck_node_ratio) * -400.0
		destination.y -= height_curve.sample(deck_node_ratio) * 100.0
		card.rotation = rotation_curve.sample(deck_node_ratio) * 0.2
		card.position = destination

func _position_rest(selectedCard):
	var deck_node = $deck 
	for card in deck_node.get_children():
		if card == selectedCard:
			break
		var deck_node_ratio = 0.5

		if deck_node.get_child_count() > 1:
			deck_node_ratio = float(card.get_index()) / float(deck_node.get_child_count() - 2)

		var destination = deck_node.position
		destination.x += spread_curve.sample(deck_node_ratio) * -400.0
		destination.y -= height_curve.sample(deck_node_ratio) * 100.0
		card.rotation = rotation_curve.sample(deck_node_ratio) * 0.2
		card.position = destination
		
func _on_card_pressed(card):
	if animationInProgress:
		return  # Exit if an animation is already in progress

	animationInProgress = true

	if selected_card and selected_card != card:
		# Move the previously selected card back to its position
		reset_card_position(selected_card)

	var pressed_card = get_node("deck/" + card.name)
	selected_card = pressed_card  # Update the selected card

	pressed_card.rotation = 0
	var current_position = pressed_card.position
	pressed_card.position = Vector2(current_position.x, current_position.y - 500)

	var animation_player = pressed_card.get_node("AnimationPlayer")
	animation_player.play("card_move_up")

func _on_info_pressed(card):
	var pressed_card = get_node("deck/" + card.name)
	pressed_card.rotation = 0
	var animation_player = pressed_card.get_node("AnimationPlayer")
	animation_player.play("popup")
	
func _on_animation_finished(animation_name):
	animationInProgress = false
func reset_card_position(card):
	var deck_node = $deck 
	var deck_node_ratio = 0.5

	if deck_node.get_child_count() > 1:
		deck_node_ratio = float(card.get_index()) / float(deck_node.get_child_count() - 1)

	var destination = deck_node.position
	destination.x += spread_curve.sample(deck_node_ratio) * -400.0
	destination.y -= height_curve.sample(deck_node_ratio) * 100.0
	card.rotation = rotation_curve.sample(deck_node_ratio) * 0.2
	card.position = destination

func _process(delta):
	pass
