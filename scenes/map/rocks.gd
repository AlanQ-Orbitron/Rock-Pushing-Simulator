extends TileMapLayer
@onready var Floor: TileMapLayer = $"../Floor"

func moveCell(currentPosition: Vector2, direction: Vector2) -> void:
	var newPosition: Vector2i = currentPosition + direction
	var floorData: Variant = Floor.get_cell_tile_data(newPosition)
	var isRock: bool = get_cell_tile_data(newPosition) != null
	var isBoundry: bool = false
	if floorData != null:
		isBoundry = floorData.get_custom_data("Floor")
	if !isBoundry || isRock:
		return
	var currentTile: Vector2i = get_cell_atlas_coords(currentPosition)
	var currentID: int = get_cell_source_id(currentPosition)
	erase_cell(currentPosition)
	set_cell(newPosition, currentID, currentTile)
