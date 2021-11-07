extends Path2D


export(Resource) var grid

export(NodePath) var FollowerPath
onready var Follower = get_node(FollowerPath)
export(NodePath) var CursorPath
onready var Cursor = get_node(CursorPath)

var MovingUnit : KinematicBody2D setget set_moving_unit

var CurrentCell : Vector2 setget set_current_cell

func _ready():
	CurrentCell = grid.calc_grid_coord(self.position)
	self.position = grid.calc_map_pos(CurrentCell)

func set_current_cell(new_cell: Vector2):
	CurrentCell = grid.clamp_to_grid(new_cell)

func set_moving_unit(body):
	MovingUnit = body

func set_path(path:PoolVector2Array):
	if path.empty():
		return
	set_current_cell(MovingUnit.CurrentCell)
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calc_map_pos(point) - position)
	CurrentCell = path[-1]

