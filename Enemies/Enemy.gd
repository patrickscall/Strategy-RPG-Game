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
export(NodePath) var MoveArrowPath
onready var moveArrow = get_node(MoveArrowPath)


var currentCell : Vector2
var path : Curve2D
var pathArray : PoolVector2Array
var cellsInRange : Array = []
var cellsInAttackRange : Array = []
var unitsInRange : Array = []
var walking : bool


var highlighted : bool = false setget set_highlighted

func _ready():
	set_cell()
	TurnHandler.add_to_list(self,TurnHandler.enemyList)
	TurnHandler.connect("refresh_enemyList", self, "add_to_enemyList")

func set_cell():
	currentCell = map.world_to_map(self.get_global_position())

func set_highlighted(value : bool):
	highlighted = value
	fill_movement_range(currentCell,moveRange)
	rangeOverlay.set_visible(value)
	
func fill_movement_range(origin:Vector2,moverange:int):
	var q : PoolVector2Array
	cellsInRange = map.get_cells_in_range(origin,moverange)
	cellsInAttackRange = map.get_cells_in_attack_range(cellsInRange,attackRange.x,attackRange.y)
	for i in cellsInRange.size():
		rangeOverlay.set_cellv(cellsInRange[i],0)
	for i in cellsInAttackRange.size():
		if !cellsInRange.has(cellsInAttackRange[i]):
			q.append(cellsInAttackRange[i])
	for i in q.size():
		rangeOverlay.get_child(0).set_cellv(q[i],0)


func set_path_to(target:Vector2):
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

func get_units_in_range():
	var q :  Array
	unitsInRange.clear()
	for i in TurnHandler.unitList.size():
		if cellsInAttackRange.has(TurnHandler.unitList[i].currentCell):
			unitsInRange.append(TurnHandler.unitList[i])
	print(unitsInRange)
	if unitsInRange.size() > 0:
		return true
	else:
		return false


func get_closest_target():
	if get_units_in_range():
		var p = moveRange + attackRange.y
		for i in unitsInRange.size():
			var q = unitsInRange[i].currentCell
			var e = map.costToOrigin[(map.cellPositions as Array).find(q)]
			if e <= p:
				p = e
				set_path_to(q)
				walking = true
				self.unit_offset = 1



func add_to_enemyList():
	TurnHandler.enemyList.append(self)

func take_turn():
	map.moveRange = moveRange
	map.target = currentCell
	fill_movement_range(currentCell, moveRange)
	set_highlighted(false)
	get_closest_target()

func _process(delta):
	if walking:
		move_along_path(delta)



