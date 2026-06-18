extends TileMapLayer

@onready var camera_2d: Camera2D = %Camera2D
@onready var Floor: TileMapLayer = %Floor
@onready var Objects: TileMapLayer = %Objects
@onready var switches: Node2D = %Switches

var hasWalked: bool = false
var playerPosition: Vector2 = Vector2.ZERO
var playerDirection: Vector2i = Vector2.ZERO
var movementHistory: Array[MoveHistory] = []
signal movement_input

func _ready() -> void:
	playerPosition = get_used_cells()[0]

func _unhandled_input(event: InputEvent) -> void:
	var direction: Vector2 = Vector2.ZERO
	if event.is_action_pressed("left"):
		direction.x = -1
	if event.is_action_pressed("right"):
		direction.x = 1
	if event.is_action_pressed("forwards"):
		direction.y = -1
	if event.is_action_pressed("backwards"):
		direction.y = 1
	if event.is_action_pressed("action"):
		talk(playerDirection)
	if event.is_action_pressed("undo"):
		if movementHistory.size() > 0:
			var history: MoveHistory = movementHistory.pop_back()
			if history.isType("move"):
				moveCell(history.movementDirection * -1, true)
				if movementHistory.size() > 0 && movementHistory[-1].isType("object"):
					history = movementHistory.pop_back()
			if history.isType("object"):
				Objects.moveCell(history.currentPosition + history.movementDirection, history.movementDirection * -1)
	if direction != Vector2.ZERO:
		if !hasWalked:
			hasWalked = true
			Global.emit_signal("wakeUp")
		playerDirection = direction
		pushRocks(direction)
		moveCell(direction)
		movement_input.emit()

func checkTile(tileLayer: TileMapLayer, newPosition: Vector2) -> bool:
	return tileLayer.get_cell_tile_data(newPosition) != null

func talk(direction: Vector2) -> void:
	var lookingDirection: Vector2i = playerPosition + direction
	if Objects.get_cell_tile_data(lookingDirection) != null:
		Global.emit_signal(
			"talk",
			Objects.get_cell_atlas_coords(lookingDirection),
			Objects.get_cell_source_id(lookingDirection)
		)

func pushRocks(direction: Vector2) -> void:
	var newPosition: Vector2i = playerPosition + direction
	if checkTile(Objects, newPosition):
		movementHistory.append(MoveHistory.new("object", newPosition,  direction))
		Objects.moveCell(newPosition, direction)

func moveCell(direction: Vector2, history: bool = false) -> void:
	var newPosition: Vector2i = playerPosition + direction
	var floorData: Variant = Floor.get_cell_tile_data(newPosition)
	var isBoundry: bool = false
	if floorData != null:
		isBoundry = floorData.get_custom_data("Floor")
	if !isBoundry || checkTile(Objects, newPosition):
		return
	if !history:
		movementHistory.append(MoveHistory.new("move", playerPosition, direction))
	camera_2d.position = map_to_local(newPosition)
	var currentTile: Vector2i = get_cell_atlas_coords(playerPosition)
	var currentID: int = get_cell_source_id(playerPosition)
	erase_cell(playerPosition)
	set_cell(newPosition, currentID, currentTile)
	playerPosition += direction
