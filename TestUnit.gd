extends KinematicBody2D

export(NodePath) var MoveTargetPath
onready var MoveTarget = get_node(MoveTargetPath)

export(int,10) var MovementRange = 5

var Selected : bool



func _ready():
	pass

func set_selected(var is_selected :bool = false):
	Selected = is_selected
	$SelectedIcon.set_visible(is_selected)

func _set_target_pos(var newtargetpos : Vector2 = Vector2.ZERO):
	MoveTarget.set_global_position(newtargetpos)

func add_pathing(var newpoint : Vector2):
	$Path2D.Curve2D.add_point(newpoint)

func clear_pathing():
	$Path2D.Curve2D.clear_points()


func move():
	self.set_global_position(MoveTarget.get_global_position())
	MoveTarget.set_position(Vector2.ZERO)
	

