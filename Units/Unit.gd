tool
class_name Unit
extends Path2D

signal walk_finished

export(Resource) var grid
export(int) var MoveRange = 3
export(int) var MoveSpeed = 600

var CurrentCell : Vector2 setget set_cell
var IsSelected : bool = false setget set_is_selected
var IsWalking : bool = false setget set_is_walking

export(NodePath) var SpritePath
onready var UnitSprite = get_node(SpritePath)
export(NodePath) var AnimPlayerPath
onready var AnimPlayer = get_node(AnimPlayerPath)
export(NodePath) var FollowerPath
onready var Follower = get_node(FollowerPath)



func _ready() -> void:
	set_process(false)
	
	self.CurrentCell = grid.calculate_grid_coordinates(self.position)
	self.position = grid.calculate_map_position(CurrentCell)
	
	if not Engine.editor_hint:
		curve = Curve2D.new()



func walk_along(path: PoolVector2Array) -> void:
	if path.empty():
		return
	
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calculate_map_position(point) - position)
	CurrentCell = path[-1]
	self.IsWalking = true

func set_cell(value: Vector2) -> void:
	CurrentCell = grid.clamp_to_grid(value)

func set_is_selected(value: bool) -> void:
	IsSelected = value
	if IsSelected:
		AnimPlayer.play("Selected")
	else:
		AnimPlayer.play("Idle")

func set_is_walking(value: bool) -> void:
	IsWalking = value
	set_process(IsWalking)



func _process(delta) -> void:
	Follower.offset += MoveSpeed * delta
	
	if Follower.offset >= curve.get_baked_length():
		self.IsWalking = false
		Follower.offset = 0
		position = grid.calculate_map_position(CurrentCell)
		curve.clear_points()
		emit_signal("walk_finished")
