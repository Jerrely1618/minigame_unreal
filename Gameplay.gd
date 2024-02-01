extends Node2D

const CARD = preload("res://Card.tscn")
const HAND_WIDTH = 10.0
@export var spread_curve: Curve
@export var height_curve: Curve
@export var rotation_curve: Curve

var aCardSelected = false

func _ready():
	var deck_node = $deck 
	for _x in 5:
		var card = CARD.instantiate()
		card.name = "Card_" + str(_x)
		deck_node.add_child(card)

		# Connect the signal dynamically when the card is instantiated
		card.connect("pressed", Callable(_on_card_pressed).bind(card))

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
		card.get_child(1).text = str(card.get_index())

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
	var deck_node = $deck 
	print(aCardSelected)
	if not aCardSelected:
		aCardSelected = true
		var pressed_card = get_node("deck/" + card.name)
		pressed_card.rotation = 0
		var animation_player = pressed_card.get_node("AnimationPlayer")
		animation_player.play("card_move_up")
		_position_rest(pressed_card)
	else:
		aCardSelected = false
		_position_cards()
		
func _process(delta):
	pass
