extends Node2D

signal hover_start(card)
signal hover_end(card)

var initial_position
var raised_position
var mouse_inside = false


@export var card_type: Globals.CardType = Globals.CardType.MoveFreely
@export var distance: int = 5

func init(type, distance):
	card_type = type
	distance = distance
	print("init", type, distance)

func _ready() -> void:
	if card_type == Globals.CardType.MoveFreely:
		var image = Image.load_from_file("res://assets/move5.png")
		var texture = ImageTexture.create_from_image(image)
		$sprite.texture = texture
	elif card_type == Globals.CardType.MoveStraight:
		var image = Image.load_from_file("res://assets/slide5.png")
		var texture = ImageTexture.create_from_image(image)
		$sprite.texture = texture
	set_position(position)

func can_achieve_character_move(from, to, path):
	print(from, to, path)
	if card_type == Globals.CardType.MoveFreely:
		return len(path) - 1 <= distance
	elif card_type == Globals.CardType.MoveStraight:
		return (from.x == to.x or from.y == to.y) and len(path) - 1 <= distance

func move_up():
	raised_position = initial_position + Vector2(0, -60)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", raised_position, 0.1)

func move_down():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", initial_position, 0.1)

func darken():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.5, 0.5, 0.5), 0.1)

func lighten():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)

func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true
	hover_start.emit(self)

func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false
	hover_end.emit(self)
