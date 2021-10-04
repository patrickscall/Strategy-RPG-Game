tool
class_name Cursor
extends Node2D

signal accept_pressed(cell)
signal moved(new_cell)

export(Resource) var grid
export(float, 0.1, 1, 0.1) var UiCooldown = 0.1
export(NodePath) var UICooldownTimerPath
onready var UiCooldownTimer :Timer = get_node(UICooldownTimerPath)
export(NodePath) var AnimationPlayerPath
onready var AnimPlayer = get_node(AnimationPlayerPath)

var CurrentCell : Vector2 setget set_cell
var HasSelected : bool = false setget set_has_selected


func _ready() -> void:
	UiCooldownTimer.set_wait_time(UiCooldown)
	self.set_position(grid.calculate_map_position(CurrentCell))
	AnimPlayer.play("Idle")
	


func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.set_cell(grid.calculate_grid_coordinates(event.position))
	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed", CurrentCell)
		get_tree().set_input_as_handled()
	var should_move = event.is_pressed()
	if event.is_echo():
		should_move = should_move and UiCooldownTimer.is_stopped()
	if not should_move:
		return
	
	if event.is_action("ui_right"):
		self.CurrentCell += Vector2.RIGHT
	elif event.is_action("ui_up"):
		self.CurrentCell += Vector2.UP
	elif event.is_action("ui_left"):
		self.CurrentCell += Vector2.LEFT
	elif event.is_action("ui_down"):
		self.CurrentCell += Vector2.DOWN

#func _draw() -> void:
#	draw_rect(Rect2(-grid.CellSize/2, grid.CellSize), Color.aliceblue, false, 2.0)

func set_cell(value: Vector2) -> void:
	if not grid.is_within_bounds(value):
		CurrentCell = grid.clamp_to_grid(value)
	else:
		CurrentCell = value
	position = grid.calculate_map_position(CurrentCell)
	emit_signal("moved", CurrentCell)
	UiCooldownTimer.start()

func set_has_selected(value: bool) -> void:
	if HasSelected:
		self.set_modulate(Color(1,1,1))
	else:
		self.set_modulate(Color(0.1, 0.6, 1))
	HasSelected = !HasSelected

func get_has_selected() -> bool:
	return HasSelected


