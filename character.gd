extends CharacterBody2D

var current_cell = Vector2(0, 0)

func _ready() -> void:
	position = Vector2(0, 0)

func cell_to_position(cell: Vector2):
	return cell * Globals.tile_size_game_px

func move_along_path(path):
	var movement_tween = get_tree().create_tween()
	for intermediate_cell in path:
		var intermediate_position = cell_to_position(intermediate_cell)
		movement_tween.tween_property(self, "position", intermediate_position, 0.1)
		current_cell = intermediate_cell
