class_name Grid
extends Resource

export(Vector2) var cellSize = Vector2(64,64)
var unwalkableCells : PoolVector2Array


func snap_to_grid(obj, grid_pos: Vector2):
	obj.set_global_position(grid_pos * 64)

func calc_grid_coord(global_pos: Vector2) -> Vector2:
	return(global_pos/cellSize).floor()

func clear_unwalkable():
	if !unwalkableCells.empty():
		unwalkableCells.resize(0)
#		for i in unwalkableCells.size():
#			unwalkableCells.remove(unwalkableCells.size()-i)

func add_unwalkable(cell: Vector2):
	unwalkableCells.append(cell)

func is_walkable(cell: Vector2) -> bool:
	return cell in unwalkableCells
