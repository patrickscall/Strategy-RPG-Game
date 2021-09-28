class_name GameBoard
extends Node2D

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

export(Resource) var grid

var Units : Dictionary
var ActiveUnit : Unit
var WalkableCells : Array

export(NodePath) var OverlayPath
onready var Overlay : UnitOverlay = get_node(OverlayPath)
export(NodePath) var PathingPath
onready var Pathing : UnitPath = get_node(PathingPath)
export(NodePath) var CursorPath
onready var PlayerCursor = get_node(CursorPath)


func _ready() -> void:
	_reinitialize()

func _unhandled_input(event: InputEvent) -> void:
	if ActiveUnit and event.is_action_pressed("ui_cancel"):
		_deselect_active_unit()
		_clear_active_unit()

func _get_configuration_warning() -> String:
	var warning : String
	if not grid:
		warning = "You need a Grid resource for this node to work."
	return warning

func is_occupied(cell: Vector2) -> bool:
	return Units.has(cell)

func get_walkable_cells(unit: Unit) -> Array:
	return _flood_fill(unit.CurrentCell, unit.MoveRange)

func _reinitialize() -> void:
	Units.clear()
	
	for child in get_children():
		var unit = child as Unit
		if not unit:
			continue
		Units[unit.CurrentCell] = unit

func _flood_fill(cell: Vector2, max_distance: int) -> Array:
	var array : Array
	var stack : Array = [cell]
	while not stack.empty():
		var current = stack.pop_back()
		if not grid.is_within_bounds(current):
			continue
		if current in array:
			continue
	
		var difference: Vector2 = (current - cell).abs()
		var distance : int = difference.x + difference.y
		if distance > max_distance:
			continue
	
		array.append(current)
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if is_occupied(coordinates):
				continue
			if coordinates in array:
				continue
			
			stack.append(coordinates)
	return array


func _move_active_unit(new_cell: Vector2) -> void:
	if is_occupied(new_cell) or not new_cell in WalkableCells:
		return
	Units.erase(ActiveUnit.CurrentCell)
	Units[new_cell] = ActiveUnit
	_deselect_active_unit()
	ActiveUnit.walk_along(Pathing.CurrentPath)
	yield(ActiveUnit, "walk_finished")
	_clear_active_unit()


func _select_unit(cell: Vector2) -> void:
	if not Units.has(cell):
		return
		PlayerCursor.set_has_selected(false)
	ActiveUnit = Units[cell]
	ActiveUnit.set_is_selected(true)
	WalkableCells = get_walkable_cells(ActiveUnit)
	Overlay.draw(WalkableCells)
	Pathing.initialize(WalkableCells)
	PlayerCursor.set_has_selected(true)


func _deselect_active_unit() -> void:
	ActiveUnit.set_is_selected(false)
	Overlay.clear()
	Pathing.stop()
	PlayerCursor.set_has_selected(false)


func _clear_active_unit() -> void:
	ActiveUnit = null
	WalkableCells.clear()


func _on_Cursor_accept_pressed(cell: Vector2) -> void:
	if not ActiveUnit:
		_select_unit(cell)
	elif ActiveUnit.IsSelected:
		_move_active_unit(cell)

func _on_Cursor_moved(new_cell: Vector2) -> void:
	if ActiveUnit and ActiveUnit.IsSelected:
		Pathing.draw(ActiveUnit.CurrentCell, new_cell)

