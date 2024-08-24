extends Node2D


var cards
var hovered_card = null
# Called when the node enters the scene tree for the first time.
var astar_grid = AStarGrid2D.new()

func _ready() -> void:
	position = Vector2(0, 0)
	astar_grid.region = Rect2i(0, 0, 16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	var ore_cells = $level.get_node("ores").get_used_cells()
	print(ore_cells)
	astar_grid.update()
	for cell in ore_cells:
		print(cell)
		astar_grid.set_point_solid(cell)

	$ui_grid.connect("update_position", _on_update_mouse_cell)

	cards = [
		create_card(Globals.CardType.MoveFreely, 5),
		create_card(Globals.CardType.MoveFreely, 5),
		create_card(Globals.CardType.MoveStraight, 5),
	]
	cards.reverse()
	layout_hand()

var card_scene = preload("res://scenes/card.tscn")

func create_card(type, distance):
	var card = card_scene.instantiate()
	card.init(type, distance)
	add_child(card)
	card.hover_start.connect(_on_card_enter)
	card.hover_end.connect(_on_card_exit)
	return card
	
func layout_hand():
	var current = Vector2(72, 156)
	for i in len(cards):
		cards[i].position = current
		cards[i].initial_position = current
		current += Vector2(24, 0)

func calc_path(from_cell, to_cell):
	# TODO
	return astar_grid.get_id_path(from_cell, to_cell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
			var cell = $ui_grid.get_mouse_cell(event.position)
			print("clicked on ", cell)
			attempt_move_character(cell)

func attempt_move_character(cell):
		var path = calc_path($character.current_cell, cell)
		for i in len(cards):
			if cards[i].can_achieve_character_move($character.current_cell, cell, path):
				cards[i].queue_free()
				cards.remove_at(i)
				$character.move_along_path(path)
				break

func get_top_hovered_card():
	for card in cards:
		if card.mouse_inside:
			return card
	return null
	
func update_hovered_card():
	var top_hovered_card = get_top_hovered_card()
	if top_hovered_card != hovered_card:
		if hovered_card != null:
			hovered_card.move_down()
		if top_hovered_card != null:
			top_hovered_card.move_up()
		hovered_card = top_hovered_card

func _on_card_enter(card):
	update_hovered_card()

func _on_card_exit(card):
	update_hovered_card()

func _on_update_mouse_cell(cell):
	var can_move = false
	for card in cards:
		if card.can_achieve_character_move($character.current_cell, cell, calc_path($character.current_cell, cell)):
			can_move = true
			card.lighten()
		else:
			card.darken()
	if can_move:
		$ui_grid.set_green()
	else:
		$ui_grid.set_red()
