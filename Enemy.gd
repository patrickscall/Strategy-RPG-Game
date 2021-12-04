class_name EnemyUnit
extends PathFollow2D

export(int) var moveRange = 3
var moveSpeed = 600

export(int) var Health = 10
export(int) var Attack = 1
export(Vector2) var attackRange = Vector2(1,1)

var currentCell : Vector2
var highlighted : bool = false setget set_highlighted

export(NodePath) var SpritePath
onready var UnitSprite = get_node(SpritePath)
export(NodePath) var AnimPlayerPath
onready var AnimPlayer = get_node(AnimPlayerPath)
export(NodePath) var PathNode
onready var pathNode = get_node(PathNode)
export(NodePath) var TerrainMapPath
onready var map = get_node(TerrainMapPath)
export(NodePath) var EnemyRangeOverlayPath
onready var enemyRangeOverlay = get_node(EnemyRangeOverlayPath)



var unitsInRange : Array
var cellsInRange : Array
var cellsInAttackRange : Array

var path : Curve2D
var pathArray : PoolVector2Array
var walking : bool = false

func _ready():
	set_cell()
	

func set_cell():
	currentCell = map.world_to_map(self.get_global_position())


func fill_movement_range(origin:Vector2,moverange:int):
	cellsInRange = map.get_cells_in_range(origin,moverange)
	cellsInAttackRange = map.get_cells_in_range(origin,moverange + attackRange.y)
	for i in cellsInAttackRange.size():
		enemyRangeOverlay.set_cellv(cellsInRange[i],0)


func clear_movement_range():
	enemyRangeOverlay.clear()

func set_highlighted(value):
	if value:
		fill_movement_range(currentCell,moveRange)
	else:
		clear_movement_range()


func set_path(target:Vector2):
	path = Curve2D.new()
	if target != currentCell:
		pathArray = map.create_path(target,currentCell)
		for i in pathArray.size():
			var x = map.map_to_world(pathArray[i])
			path.add_point(x)
	pathNode.set_curve(path)

func move_along_path(delta):
	if self.unit_offset > 0:
		self.offset -= moveSpeed * delta
	else:
		walking = false
		print(self.position)
		path.clear_points()
		pathNode.set_curve(path)
		set_cell()


