extends PopupMenu

export(NodePath) var PlayerCursorPath
onready var PlayerCursor

export(Vector2) var MenuDimensions = Vector2(50,100)

func _ready():
	pass

func show_menu(value:bool):
	if value:
		self.popup(Rect2(PlayerCursor.CurrentCell, MenuDimensions))
	else:
		self.hide()
