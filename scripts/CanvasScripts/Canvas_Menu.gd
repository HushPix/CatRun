class_name Canvas_Menu
extends Control

enum menu_state {
	hidden,
	shown,
}

var currentMenuState: menu_state

func _hideMenu(menu: Canvas_Menu = self) -> void:
	if menu.currentMenuState == menu_state.shown:
		menu.currentMenuState = menu_state.hidden
		menu.hide()

func _showMenu(menu: Canvas_Menu = self) -> void:
	if menu.currentMenuState == menu_state.hidden:
		menu.currentMenuState = menu_state.shown
		menu.show()
		
func _updateScore(label: Label, isHiScore: bool, collectibleManager: CollectibleManager) -> void: #updates the score every frame
	if(isHiScore):
		label.text = "BEST:" + str(collectibleManager.getHighScore())
	else:
		label.text = str(collectibleManager.getScore())
