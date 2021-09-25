
class_name Unit
extends Path2D

export(Resource) var grid
export(NodePath) var FollowerPath
onready var Follower = get_node(FollowerPath)
export(int) var MoveRange = 3
export(int) var Speed = 600



var CurrentCell : Vector2 setget set_current_cell

var IsSelected : bool = false
var IsWalking : bool = false



func _ready():
	pass


func set_current_cell(var value:Vector2) -> void:
	CurrentCell = grid.clamp(value)

func set_is_selected(var sel:bool) -> void:
	IsSelected = sel
