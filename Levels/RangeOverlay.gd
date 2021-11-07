extends TileMap

export(NodePath) var TerrainMap
onready var map = get_node(TerrainMap)

var filledCells : PoolVector2Array

func _ready():
	fill_movement_range(map.target,map.MoveRange)

func fill_movement_range(origin:Vector2,moverange:int):
	filledCells = map.get_cells_in_range(origin,moverange)
	for i in filledCells.size():
		set_cellv(filledCells[i],0)
