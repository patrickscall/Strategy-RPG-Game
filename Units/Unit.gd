class_name Unit
extends PathFollow2D


export(int) var moveRange = 3
var moveSpeed = 600

export(int) var Health = 10
export(int) var Attack = 1
export(int) var MaxAttackRange = 1
export(int) var MinAttackRange = 1

var currentCell : Vector2
var selected : bool = false setget set_selected

export(Texture) var texture
onready var sprite = $Sprite
onready var AnimPlayer = $Sprite/AnimationPlayer
onready var pathNode = get_parent()
export(NodePath) var TerrainMapPath
onready var map = get_node(TerrainMapPath)
export(NodePath) var RangeOverlayPath
onready var rangeOverlay = get_node(RangeOverlayPath)
export(NodePath) var MoveArrow
onready var moveArrow = get_node(MoveArrow)
onready var area = $Area2D/CollisionShape2D



var CanAttack : bool = false
var EnemiesInRange : Array
var cellsInRange : Array

var path : Curve2D
var pathArray : PoolVector2Array
var walking : bool = false



func _ready():
	set_cell()
	TurnHandler.add_to_list(self, TurnHandler.unitList)
	TurnHandler.connect("refresh_unitList", self, "add_to_unitList")


func set_cell():
	currentCell = map.world_to_map(self.get_global_position())


func fill_movement_range(origin:Vector2,moverange:int):
	cellsInRange = map.get_cells_in_range(origin,moverange)
	for i in cellsInRange.size():
		rangeOverlay.set_cellv(cellsInRange[i],0)


func clear_movement_range():
	rangeOverlay.clear()


func draw_path(target:Vector2):
	moveArrow.clear()
	path = Curve2D.new()
	if target != currentCell:
		pathArray = map.create_path(target,currentCell)
		for i in pathArray.size():
			var x = map.map_to_world(pathArray[i])
			path.add_point(x)
			moveArrow.set_cellv(pathArray[i],0)
			moveArrow.update_bitmask_area(pathArray[i])
	moveArrow.set_modulate(Color(0, 0.5, 1))
	pathNode.set_curve(path)


func set_selected(value):
	if value:
		fill_movement_range(currentCell,moveRange)
	else:
		clear_movement_range()
		moveArrow.clear()


func move_along_path(delta):
	if self.unit_offset > 0:
		self.offset -= moveSpeed * delta
	else:
		walking = false
		path.clear_points()
		pathNode.set_curve(path)
		set_cell()
		grey_out()

func grey_out():
	sprite.set_modulate(Color(0.4,0.4,0.4))
	area.set_disabled(true)
	TurnHandler.movedUnits.append(self)
	TurnHandler.check_if_turn_over()


func start_of_turn():
	sprite.set_modulate(Color(1,1,1))
	area.set_disabled(false)

func add_to_unitList():
	TurnHandler.unitList.append(self)

func _process(delta):
	if walking:
		move_along_path(delta)

