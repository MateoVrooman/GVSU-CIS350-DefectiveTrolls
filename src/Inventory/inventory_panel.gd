extends Button

@onready var backgroundSprite: Sprite2D = $Background
@onready var container: CenterContainer = $CenterContainer

var itemStackGUI: ItemStackGUI

func insert(isg: ItemStackGUI):
	itemStackGUI = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackGUI)
