extends TileMapLayer

var current: Vector2i = Vector2i(3, 3)
var history: Array[Vector2i] = []

var tiles: Array = [
	[00, 01, 02, 03],
	[04, 05, 06, 07],
	[08, 09, 10, 11],
	[12, 13, 14, 15]
]


func _ready() -> void:
	shuffle()

func _unhandled_input(event: InputEvent) -> void:
	var mousePosition: Vector2i = local_to_map(get_local_mouse_position())
	var atlas: Vector2i = get_cell_atlas_coords(mousePosition)
	
	if event.is_action_pressed("left_click") && atlas.x == 4:
		set_cell(mousePosition, 0, Vector2i(5, atlas.y))
		match (atlas.y):
			0:
				shift_row(mousePosition.y - 3, 1)
			1:
				shift_col(mousePosition.x - 2, 1)
			2:
				shift_row(mousePosition.y - 3, -1)
			3:
				shift_col(mousePosition.x - 2, -1)
		setCell()
	if event.is_action_released("left_click") && atlas.x == 5:
		set_cell(mousePosition, 0, Vector2i(4, atlas.y))

func setCell() -> void:
	for x: int in range(4):
		for y: int in range(4):
			var color: int = tiles[y][x]
			set_cell(Vector2i(x, y) + Vector2i(2, 3), 0, Vector2i(color % 4, int(color / 4.0)))

func unShuffle() -> void:
	while history.size() > 0:
		var moves: Vector2i = history.pop_back()
		if moves.y % 2 == 0:
			shift_row(moves.x, -1)
		else:
			shift_col(moves.x, -1)
		setCell()
		await get_tree().create_timer(0.02).timeout

func shuffle() -> void:
	for i: int in range(100):
		if randi() % 2 == 0:
			var row: int = randi_range(0, 3)
			shift_row(row, 1)
			history.append(Vector2i(row, 0))
		else:
			var col: int = randi_range(0, 3)
			shift_col(col, 1)
			history.append(Vector2i(col, 1))
		setCell()
		await get_tree().create_timer(0.02).timeout

func shift_col(column: int, direction: int) -> void:
	if direction == -1:
		var first: int = tiles[0][column]
		for i: int in range(0, 3):
			tiles[i][column] = tiles[i + 1][column]
		tiles[3][column] = first
	else:
		var last: int = tiles[3][column]
		for i: int in range(3, 0, -1):
			tiles[i][column] = tiles[i - 1][column]
		tiles[0][column] = last

func shift_row(row: int, direction: int) -> void:
	if direction == -1:
		var first: int = tiles[row][0]
		for i: int in range(0, 3):
			tiles[row][i] = tiles[row][i + 1]
		tiles[row][3] = first
	else:
		var last: int = tiles[row][3]
		for i: int in range(3, 0, -1):
			tiles[row][i] = tiles[row][i - 1]
		tiles[row][0] = last
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
