class_name UnitPath
extends TileMap

export(Resource) var grid

var PathFind : PathFinder
var CurrentPath : PoolVector2Array


func initialize(walkable_cells: Array) -> void:
	PathFind = PathFinder.new(grid, walkable_cells)

func draw(cell_start: Vector2, cell_end: Vector2) -> void:
	clear()
	CurrentPath = PathFind.calculate_point_path(cell_start, cell_end)
	for cell in CurrentPath:
		set_cellv(cell,0)
		update_bitmask_region()


func stop() -> void:
	PathFind = null
	clear()
