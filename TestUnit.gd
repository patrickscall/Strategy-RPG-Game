extends KinematicBody2D

export(NodePath) var MoveTargetPath
onready var MoveTarget = get_node(MoveTargetPath)





func _ready():
	pass


func _set_target_pos(var newtargetpos : Vector2 = Vector2.ZERO):
	MoveTarget.set_global_position(newtargetpos)

func move():
	self.set_global_position(MoveTarget.get_global_position())
	MoveTarget.set_position(Vector2.ZERO)
	
#
#func _physics_process(delta):
#	if Input.is_action_just_pressed("ui_accept"):
#		move()
	

