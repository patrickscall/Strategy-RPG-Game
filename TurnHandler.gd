extends Node2D

var playerTurn : bool = true
var movedUnits : Array = []
var movedEnemies : Array = []



var unitList : Array = []
var enemyList : Array = []

signal refresh_unitList
signal refresh_enemyList


func add_to_list(item,list):
	list.append(item)




func _ready():
	unitList.clear()
	enemyList.clear()
	movedUnits.clear()
	movedEnemies.clear()

func check_if_turn_over():
	if movedUnits.size() >= unitList.size():
		playerTurn = false
		unitList.clear()
		movedUnits.clear()
		emit_signal("refresh_unitList")
		print("playerTurn ", playerTurn)
		take_enemy_turns()

func check_if_enemy_turn_over():
	if movedEnemies.size() >= enemyList.size():
		playerTurn = true
		enemyList.clear()
		movedEnemies.clear()
		emit_signal("refresh_enemyList")
		print("playerTurn ", playerTurn)

func take_enemy_turns():
	for i in enemyList.size():
		enemyList[i].take_turn()
		movedEnemies.append(enemyList[i])
		print("Moved Enemies ",movedEnemies)




