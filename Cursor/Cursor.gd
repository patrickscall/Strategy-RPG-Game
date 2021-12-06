extends Sprite




export(NodePath) var AnimationPlayerPath
onready var animPlayer = get_node(AnimationPlayerPath)
export(NodePath) var TerrainMap
onready var map = get_node(TerrainMap)


var currentCell
var hoveredArea
var hoveredBody
var selection



func _ready():
	find_cell()
	animPlayer.play("Idle")


func _unhandled_input(event):
	if TurnHandler.playerTurn:
		if event.is_action_pressed("ui_up",true):
			if selection is Unit:
				var x = map.get_cells_in_range(selection.currentCell,selection.moveRange)
				if (x as Array).find(currentCell+Vector2.UP) != -1:
					currentCell += Vector2.UP
				elif (x as Array).find(currentCell+(Vector2.UP*2)) != -1:
					currentCell += Vector2.UP*2
				selection.draw_path(currentCell)
			else:
				currentCell += Vector2.UP
		if event.is_action_pressed("ui_down",true):
			if selection is Unit:
				var x = map.get_cells_in_range(selection.currentCell,selection.moveRange)
				if (x as Array).find(currentCell+Vector2.DOWN) != -1:
					currentCell += Vector2.DOWN
				elif (x as Array).find(currentCell+(Vector2.DOWN*2)) != -1:
					currentCell += Vector2.DOWN*2
				selection.draw_path(currentCell)
			else:
				currentCell += Vector2.DOWN
				
		if event.is_action_pressed("ui_right",true):
			if selection is Unit:
				var x = map.get_cells_in_range(selection.currentCell,selection.moveRange)
				if (x as Array).find(currentCell+Vector2.RIGHT) != -1:
					currentCell += Vector2.RIGHT
				elif (x as Array).find(currentCell+(Vector2.RIGHT*2)) != -1:
					currentCell += Vector2.RIGHT*2
				selection.draw_path(currentCell)
			else:
				currentCell += Vector2.RIGHT
		if event.is_action_pressed("ui_left",true):
			if selection is Unit:
				var x = map.get_cells_in_range(selection.currentCell,selection.moveRange)
				if (x as Array).find(currentCell+Vector2.LEFT) != -1:
					currentCell += Vector2.LEFT
				elif (x as Array).find(currentCell+(Vector2.LEFT*2)) != -1:
					currentCell += Vector2.LEFT*2
				selection.draw_path(currentCell)
			else:
				currentCell += Vector2.LEFT
		
		if Input.is_action_just_pressed("ui_accept"):
			# add selection shit here
			if !selection:
				selection = hoveredArea
				if selection is Unit:
					map.moveRange = selection.moveRange
					map.target = selection.currentCell
					selection.selected = true
				if selection is Enemy:
					map.moveRange = selection.moveRange
					map.target = selection.currentCell
					selection.highlighted = !selection.highlighted
					selection = null
			else:
				if selection is Unit:
					selection.selected = false
					selection.walking = true
					selection.unit_offset = 1
					selection = hoveredArea
				if hoveredArea is Enemy:
					selection.highlighted = !selection.highlighted
					selection = null
					



func _process(delta):
	lock_to_cell()
	self.set_visible(TurnHandler.playerTurn)



func find_cell():
	currentCell = map.world_to_map(self.get_global_position())

func lock_to_cell():
	set_global_position(map.map_to_world(currentCell))


func _on_Area2D_area_entered(area):
	#display hovered info
	if area.get_parent() is PathFollow2D:
		hoveredArea = area.get_parent()
	else:
		hoveredArea = area
func _on_Area2D_area_exited(_area):
	hoveredArea = null


func _on_Area2D_body_entered(body):
	var blah = body.get_parent()
	hoveredBody = blah.get_parent()
	
func _on_Area2D_body_exited(_body):
	hoveredBody = null
