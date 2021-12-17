extends TileMap


const UP = Vector2.UP
const DOWN = Vector2.DOWN
const RIGHT = Vector2.RIGHT
const LEFT = Vector2.LEFT

var target : Vector2  setget set_target
var moveRange : int 

export(NodePath) var unitpath
onready var unit = get_node(unitpath)

export(Vector2) var mapSize = Vector2(20,20)
onready var mapRect : Rect2 = Rect2(Vector2.ZERO, mapSize)
export(NodePath) var VisibleIndexPath
onready var visibleIndex = get_node(VisibleIndexPath)

var checkRange : int

var terrainIndex : Dictionary = {
	0 : 1,      # Smooth
	1 : 2,     # Rough
	2 : 3,     # Hard
	3 : INF    # Impassable
}
var numbersIndex : Dictionary = {
	0 : 0,
	1 : 1,
	2 : 2,
	3 : 3,
	4 : 4,
	5 : 5,
	6 : 6,
	7 : 7,
	8 : 8,
	9 : 9,
	10 : 10,
	INF : 11
}

var directionIndex : Dictionary = {0:UP,1:RIGHT,2:DOWN,3:LEFT}


var cellPositions : PoolVector2Array
var cellIndex : Array
var cellCost : Array
var costToOrigin : Array
var cellsToTest: PoolVector2Array

var path : PoolVector2Array



func _ready():
	pass

func set_target(value):
	target = value
	initialize_cells(value)
	test_cells(value,moveRange)
#	show_index()


func initialize_cells(origin:Vector2):
	(cellPositions as Array).clear()
	cellPositions = get_used_cells()
	cellIndex.clear()
	cellCost.clear()
	costToOrigin.clear()
	for i in cellPositions.size():
		cellIndex.append(get_cellv(cellPositions[i]))
		cellCost.append(terrainIndex[cellIndex[i]])
		costToOrigin.append(INF)
	cellIndex[(cellPositions as Array).find(origin)] = 0
	cellCost[(cellPositions as Array).find(origin)] = 0
	costToOrigin[(cellPositions as Array).find(origin)] = 0
	for i in TurnHandler.unitList.size():
		var unitCellID = (cellPositions as Array).find(TurnHandler.unitList[i].currentCell)
		cellCost[unitCellID] = INF
	for i in TurnHandler.enemyList.size():
		var enemyCellID = (cellPositions as Array).find(TurnHandler.enemyList[i].currentCell)
		cellCost[enemyCellID] = INF

func check_if_cell_exists(cell:Vector2) -> bool:
	var value : bool
	if (cellPositions as Array).find(cell) != -1:
		value = true
	else:
		value = false
	return value



func calc_next_cell(current:Vector2,moverange:int):
	if check_if_cell_exists(current):
		var currentCellID = (cellPositions as Array).find(current)
		if check_if_cell_exists(current + UP):
			var upID = (cellPositions as Array).find(current + UP)
			if costToOrigin[upID] > cellCost[upID] + costToOrigin[currentCellID]:
				costToOrigin[upID] = cellCost[upID] + costToOrigin[currentCellID]
				cellsToTest.append(cellPositions[upID])
			if costToOrigin[upID] > moverange:
				costToOrigin[upID] = INF
		if check_if_cell_exists(current + RIGHT):
			var rightID = (cellPositions as Array).find(current + RIGHT)
			if costToOrigin[rightID] > cellCost[rightID] + costToOrigin[currentCellID]:
				costToOrigin[rightID] = cellCost[rightID] + costToOrigin[currentCellID]
				cellsToTest.append(cellPositions[rightID])
			if costToOrigin[rightID] > moverange:
				costToOrigin[rightID] = INF
		if check_if_cell_exists(current + DOWN):
			var downID = (cellPositions as Array).find(current + DOWN)
			if costToOrigin[downID] > cellCost[downID] + costToOrigin[currentCellID]:
				costToOrigin[downID] = cellCost[downID] + costToOrigin[currentCellID]
				cellsToTest.append(cellPositions[downID])
			if costToOrigin[downID] > moverange:
				costToOrigin[downID] = INF
		if check_if_cell_exists(current + LEFT):
			var leftID = (cellPositions as Array).find(current + LEFT)
			if costToOrigin[leftID] > cellCost[leftID] + costToOrigin[currentCellID]:
				costToOrigin[leftID] = cellCost[leftID] + costToOrigin[currentCellID]
				cellsToTest.append(cellPositions[leftID])
			if costToOrigin[leftID] > moverange:
				costToOrigin[leftID] = INF


func test_cells(origin:Vector2, moverange:int):
	(cellsToTest as Array).clear()
	calc_next_cell(origin,moverange)
	while cellsToTest.size() > 0:
		calc_next_cell(cellsToTest[0],moverange)
		cellsToTest.remove(0)

func get_cells_in_range(origin:Vector2, moverange:int) -> PoolVector2Array:
	test_cells(origin,moverange)
	var cellsInRange:PoolVector2Array = []
	for i in cellPositions.size():
		if costToOrigin[i] <= moverange:
			cellsInRange.append(cellPositions[i])
	return cellsInRange

func find_cheapest_adjacent_cell(current:Vector2) -> Vector2:
	if check_if_cell_exists(current):
		var upID = -1
		var rightID	= -1
		var leftID = -1
		var downID = -1
		var cheapestCellID = -1
		var compareID : Array = []
		var compareCost : Array = []
		compareCost.clear()
		compareID.clear()
		if check_if_cell_exists(current + UP):
			upID = (cellPositions as Array).find(current+UP)
			compareID.append(upID)
			compareCost.append(costToOrigin[upID])
		if check_if_cell_exists(current + RIGHT):
			rightID = (cellPositions as Array).find(current+RIGHT)
			compareID.append(rightID)
			compareCost.append(costToOrigin[rightID])
		if check_if_cell_exists(current + DOWN):
			downID = (cellPositions as Array).find(current+DOWN)
			compareID.append(downID)
			compareCost.append(costToOrigin[downID])
		if check_if_cell_exists(current + LEFT):
			leftID = (cellPositions as Array).find(current+LEFT)
			compareID.append(leftID)
			compareCost.append(costToOrigin[leftID])
		cheapestCellID = compareID[compareCost.find(compareCost.min())]
		
		return cellPositions[cheapestCellID]
	else:
		return current

func create_path(tar:Vector2,home:Vector2) -> PoolVector2Array:
	var current = tar
	path = []
	var tarID = (cellPositions as Array).find(tar)
	if costToOrigin[tarID] == INF:
		print("Out of Bounds fix this shit patrick")
	path.append(tar)
	while current != home:
		path.append(find_cheapest_adjacent_cell(current))
		current = find_cheapest_adjacent_cell(current)
	return path

func show_index():
	for i in cellPositions.size():
		var boop
		if costToOrigin[i] > 10 and costToOrigin[i] != INF:
			boop = costToOrigin[i]
			while boop > 10:
				boop -= 10
			visibleIndex.set_cellv(cellPositions[i], numbersIndex[boop])
		else:
			visibleIndex.set_cellv(cellPositions[i], numbersIndex[costToOrigin[i]])



