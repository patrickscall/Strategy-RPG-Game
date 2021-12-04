extends Node2D

var turnOver : bool = false
var movedUnits : Array = []
var movedEnemies : Array = []


func player_turn_start():
	movedUnits.clear()

func _ready():
	AutoLoad.clear_list(AutoLoad.unitList)
	AutoLoad.clear_list(AutoLoad.enemyList)
	movedUnits.clear()
	movedEnemies.clear()

func check_if_turn_over():
	if movedUnits.size() >= AutoLoad.unitList.size():
		turnOver = true
		print(turnOver)

func check_if_enemy_turn_over():
	if movedEnemies.size() >= AutoLoad.unitList.size():
		turnOver = false
		print(turnOver)


