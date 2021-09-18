# Mum's the word


extends Area2D
var gridSize : Vector2 = Vector2(64,64)
var viewPortSize : Vector2
var inputDirection : Vector2
var Speed : int
var disTraveled : int

var selected
var hovered

export (NodePath) var UnselectedMenuPath
onready var UnselectedMenu = get_node(UnselectedMenuPath)


func _process(delta):
	viewPortSize = get_viewport().size
	if Input.is_action_just_pressed("ui_down"): 
		self.position.y += 64
	if Input.is_action_just_pressed("ui_up"):
		self.position.y -= 64
	if Input.is_action_just_pressed("ui_right"):
		self.position.x += 64
	if Input.is_action_just_pressed("ui_left"):
		self.position.x -= 64
		
	if self.position.y >= viewPortSize.y:
		self.position.y = viewPortSize.y - 64
	if self.position.y < 0:
		self.position.y = 0
	if self.position.x >= viewPortSize.x:
		self.position.x = viewPortSize.x - 64
	if self.position.x < 0:
		self.position.x = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		if hovered != null:
			print(hovered)
			selected = hovered
		elif selected != null:
			selected._set_target_pos(self.get_global_position())
			selected.move()
			selected = null
	

#func moveInput():
#	inputDirection = Vector2.ZERO
#	if Input.is_action_just_pressed("ui_left"):
#		inputDirection.x = -1
#	if Input.is_action_just_pressed("ui_up"):
#		inputDirection.y = -1
#	if Input.is_action_just_pressed("ui_right"):
#		inputDirection.x = 1
#	if Input.is_action_just_pressed("ui_down"):
#		inputDirection.y = 1


#func gridMovement():
#	pass

func _ready():
	$AnimationPlayer.play("Idle")



func _on_PCursor_body_entered(body):
	hovered = body


func _on_PCursor_body_exited(body):
	hovered = null
