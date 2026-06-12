extends TileMapLayer

@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var Floor: TileMapLayer = $"../Floor"
@onready var Rocks: TileMapLayer = $"../Rocks"
@onready var tree: Area2D = $"../Tree"
@onready var Objects: TileMapLayer = $"../Objects"
@onready var switches: TileMapLayer = $"../Switches"
@onready var puzzle: Control = $"../CanvasLayer/Puzzle"
@onready var dialog: Control = $"../CanvasLayer/Dialog"

var hasWalked: bool = false
var playerPosition: Vector2 = Vector2.ZERO
var playerDirection: Vector2i = Vector2.ZERO
var movementHistory: Array[MoveHistory] = []
signal movement_input

func _ready() -> void:
	playerPosition = get_used_cells()[0]

func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo() || Global.isActionsPaused:
		return
		
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
				if movementHistory.size() > 0 && movementHistory[-1].isType("rock"):
					history = movementHistory.pop_back()
			if history.isType("rock"):
				Rocks.moveCell(history.currentPosition + history.movementDirection, history.movementDirection * -1)
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
	var newPosition: Vector2i = playerPosition + direction
	if checkTile(Rocks, newPosition) || checkTile(Objects, newPosition):
		Global.emit_signal("talk", Rocks.get_cell_atlas_coords(newPosition), Rocks.get_cell_source_id(newPosition))
	if checkTile(switches, newPosition) && switches.get_cell_atlas_coords(newPosition) == Vector2i(0, 3):
		puzzle.show()
		dialog.hide()
	elif tree.get_overlapping_bodies != null:
		Global.emit_signal("talk", Vector2(-1, 0), 0)
	
func pushRocks(direction: Vector2) -> void:
	var newPosition: Vector2i = playerPosition + direction
	if checkTile(Rocks, newPosition):
		movementHistory.append(MoveHistory.new("rock", newPosition,  direction))
		Rocks.moveCell(newPosition, direction)

func moveCell(direction: Vector2, history: bool = false) -> void:
	var newPosition: Vector2i = playerPosition + direction
	var floorData: Variant = Floor.get_cell_tile_data(newPosition)
	var isBoundry: bool = false
	if floorData != null:
		isBoundry = floorData.get_custom_data("Floor")
	if !isBoundry || checkTile(Rocks, newPosition) || checkTile(Objects, newPosition):
		return
	if !history:
		movementHistory.append(MoveHistory.new("move", playerPosition, direction))
	camera_2d.position = map_to_local(newPosition)
	var currentTile: Vector2i = get_cell_atlas_coords(playerPosition)
	var currentID: int = get_cell_source_id(playerPosition)
	erase_cell(playerPosition)
	set_cell(newPosition, currentID, currentTile)
	playerPosition += direction
