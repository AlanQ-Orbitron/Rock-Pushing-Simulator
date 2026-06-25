extends TileMapLayer

@export_category("Context")
@export var Floor: TileMapLayer
@export var Player: TileMapLayer
@export var Objects: TileMapLayer

@export_category("Connector")
@export var TilePosition: Vector2i

func _ready() -> void:
	Player.movement_input.connect(movementTrigger)
	
func movementTrigger() -> void:
	var greySwitches: bool = true
	var greenSwitches: bool = false
	for switch: Vector2i in get_used_cells():
		if get_cell_atlas_coords(switch) != Vector2i(2, 6):
			if !switchState(switch, Vector2i(0, 8), Vector2i(1, 8)):
				greySwitches = false
			if switchState(switch, Vector2i(0, 9), Vector2i(1, 9)):
				greenSwitches = true
	if greySwitches || greenSwitches:
		Floor.set_cell(TilePosition, 0, Vector2i(2, 8))
	else:
		Floor.set_cell(TilePosition, 0, Vector2i(3, 8))

func switchState(currentPosition: Vector2i, offAtlas: Vector2i, onAtlas: Vector2i) -> bool:
		if Objects.get_cell_tile_data(currentPosition) != null || Player.get_cell_tile_data(currentPosition) != null:
			set_cell(currentPosition, 0, onAtlas)
			return true
		else:
			set_cell(currentPosition, 0, offAtlas)
			return false
