class_name Enemy
extends PathFollow2D

export(int) var moveRange = 3
# X = min Y = max
export(Vector2) var attackRange = Vector2(1,1)
var moveSpeed = 600

export(Texture) var sprite
export(NodePath) var AnimationPlayerPath
onready var animPlayer = get_node(AnimationPlayerPath)

export(NodePath) var TerrainMap
onready var map = get_node(TerrainMap)
onready var pathNode = get_parent()
export(NodePath) var EnemyRangeOverlay
onready var rangeOverlay = get_node(EnemyRangeOverlay)
export(NodePath) var TurnHandlerPath
onready var turnHandler = get_node(TurnHandlerPath)

var currentCell : Vector2
var path : Curve2D
var pathArray : PoolVector2Array
var cellsInRange : Array = []
var cellsInAttackRange : Array = []
var walking : bool


var highlighted : bool = false setget set_highlighted

func _ready():
	set_cell()
	AutoLoad.add_to_list(self,AutoLoad.enemyList)

func set_cell():
	currentCell = map.world_to_map(self.get_global_position())

func set_highlighted(value):
	highlighted = value
	fill_movement_range(currentCell,moveRange)
	rangeOverlay.set_visible(value)

func fill_movement_range(origin:Vector2,moverange:int):
	cellsInRange = map.get_cells_in_range(origin,moverange)
	cellsInAttackRange = map.get_cells_in_range(origin,moverange+attackRange.y)
	for i in cellsInAttackRange.size():
		rangeOverlay.set_cellv(cellsInAttackRange[i],0)

func draw_path(target:Vector2):
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
		path.clear_points()
		pathNode.set_curve(path)
		set_cell()
		turnHandler.movedEnemies.append(self)



