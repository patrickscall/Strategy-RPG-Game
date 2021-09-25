extends Area2D
var gridSize : Vector2 = Vector2(64,64)
var viewPortSize : Vector2
var inputDirection : Vector2
var Speed : int
var disTraveled : int

enum MoveDir {Up,Down,Left,Right}
var CurrentMoveDir = MoveDir.Up
var StartPos : Vector2
var CurrentPos : Vector2


var CanPlace : bool = true
var selected
var hovered
export(NodePath) var SpritePath
onready var CursorSprite = get_node(SpritePath)

var LastColor : Color




func _process(_delta):
	# cursor movement
	if Input.is_action_just_pressed("ui_down"): 
		self.position.y += 64
		CurrentMoveDir = MoveDir.Down
	if Input.is_action_just_pressed("ui_up"):
		self.position.y -= 64
		CurrentMoveDir = MoveDir.Up
	if Input.is_action_just_pressed("ui_right"):
		self.position.x += 64
		CurrentMoveDir = MoveDir.Right
	if Input.is_action_just_pressed("ui_left"):
		self.position.x -= 64
		CurrentMoveDir = MoveDir.Left
	
	# lock cursor to viewport
	viewPortSize = get_viewport().size
	if self.position.y >= viewPortSize.y:
		self.position.y = viewPortSize.y - 64
		CurrentMoveDir = MoveDir.Up
	if self.position.y < 0:
		self.position.y = 0
		CurrentMoveDir = MoveDir.Down
	if self.position.x >= viewPortSize.x:
		self.position.x = viewPortSize.x - 64
		CurrentMoveDir = MoveDir.Left
	if self.position.x < 0:
		self.position.x = 0
		CurrentMoveDir = MoveDir.Right
	
	# selecting and moving units
	if Input.is_action_just_pressed("ui_accept"):
		if hovered and !selected:
			print(hovered)
			selected = hovered
			change_sprite_color(Color(0.25, 0.7, 1))
			selected.set_selected(true)
			StartPos = self.get_global_position()
		elif selected and CanPlace: #placing unit on same space
				selected._set_target_pos(self.get_global_position())
				selected.move()
				selected.set_selected(false)
				selected = null
				change_sprite_color(Color(1, 1, 1))
	if selected:
		limit_movement(selected.MovementRange)




func _ready():
	$AnimationPlayer.play("Idle")


func limit_movement(var moverange):
	CurrentPos = self.get_global_position()
	if (StartPos - CurrentPos).length() > 64 * moverange:
		CanPlace = false
		change_sprite_color(Color(0.5, 0.5, 0.5))
	else:
		if !hovered:
			CanPlace = true
		change_sprite_color(Color(0.25, 0.7, 1))

func change_sprite_color(var color : Color):
	LastColor = CursorSprite.get_modulate()
	CursorSprite.set_modulate(color)




func _on_PCursor_body_entered(body):
	if selected:
		CanPlace = false
	hovered = body


func _on_PCursor_body_exited(_body):
	hovered = null

