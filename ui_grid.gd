extends Node2D
var grid_pixel_size = Globals.game_px_size * Globals.tile_size_game_px
var grid_position

signal update_position(new)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_green()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_mouse_cell(mouse_pos: Vector2) -> Vector2:
	return Vector2(floor(mouse_pos.x / grid_pixel_size), floor(mouse_pos.y / grid_pixel_size))

func _unhandled_input(event: InputEvent) -> void:
	# get mouse position whenever it moves
	if event is InputEventMouse:
		var new_grid_position = get_mouse_cell(event.position)
		if new_grid_position != grid_position:
			grid_position = new_grid_position
			update_position.emit(grid_position)
			position = grid_position * Globals.tile_size_game_px


func set_red():
	modulate = Color(0.59, 0.22, 0.16, 1)

func set_green():
	modulate = Color(0.32, 0.72, 0.42, 1)

