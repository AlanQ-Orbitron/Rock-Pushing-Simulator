extends TileMapLayer
@onready var player: TileMapLayer = $"../Player"
@onready var Rocks: TileMapLayer = $"../Rocks"
@onready var platforms: Node2D = $"../Platforms"
@onready var Floor: TileMapLayer = $"../Floor"

func _ready() -> void:
	player.movement_input.connect(movementTrigger)
	
func movementTrigger() -> void:
	for switch: Vector2 in get_used_cells():
		if get_cell_atlas_coords(switch) == Vector2i(0, 3):
			continue
		if Rocks.get_cell_tile_data(switch) != null || player.get_cell_tile_data(switch) != null:
			set_cell(switch, 0, Vector2(7, 0))
		else:
			set_cell(switch, 0, Vector2(6, 0))
	for platform: Marker2D in platforms.get_children():
		var isOrSolid: bool = false
		for switch: Vector2 in platform.orSwitches:
			if get_cell_atlas_coords(switch) == Vector2i(7, 0):
				isOrSolid = true
		var isAndSolid: bool = true
		if platform.andSwitches.size() == 0:
			isAndSolid = false
		for switch: Vector2 in platform.andSwitches:
			if get_cell_atlas_coords(switch) == Vector2i(6, 0):
				isAndSolid = false
		
		if isOrSolid || isAndSolid:
			Floor.set_cell(local_to_map(platform.position), 0, Vector2(6, 1))
		else:
			Floor.set_cell(local_to_map(platform.position), 0, Vector2(7, 1))
