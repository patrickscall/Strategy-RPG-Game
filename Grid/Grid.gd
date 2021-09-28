class_name Grid
extends Resource

export(Vector2) var Size = Vector2(20,20)
export(Vector2) var CellSize = Vector2(64,64)
var HalfCellSize = CellSize/2

func calculate_map_position(grid_pos:Vector2) -> Vector2:
	return grid_pos * CellSize + HalfCellSize

func calculate_grid_coordinates(map_pos: Vector2) -> Vector2:
	return (map_pos / CellSize).floor()

func is_within_bounds(cell_coord: Vector2) -> bool:
	var outx : bool = cell_coord.x >= 0 and cell_coord.x < Size.x
	var outy : bool = cell_coord.y >=0 and cell_coord.y < Size.y
	return outx and outy

func clamp_to_grid(grid_pos: Vector2) -> Vector2:
	var out : Vector2 = grid_pos
	out.x = clamp(out.x, 0, Size.x - 1.0)
	out.y = clamp(out.y, 0, Size.y - 1.0)
	return out

func as_index(cell: Vector2) -> int:
	return int(cell.x + Size.x * cell.y)
