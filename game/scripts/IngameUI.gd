extends CanvasLayer

@export var inGameMenu: Control
@export var saveLoadMenu: SaveLoadMenu
@export var warningScreen: ColorRect
@export var saveIdicator: TextureRect
@export var historyLabel: Label
@export var history: Control
@export var historyBox: VBoxContainer
@export var settings: Control

func _ready():
	Dialogic.Text.text_finished.connect(_on_text)

func enter_game() -> void:
	show()
	inGameMenu.hide()
	saveLoadMenu.hide()
	warningScreen.hide()
	saveIdicator.hide()
	history.hide()
	
func _on_menu_button_pressed():
	VNMain.fade(inGameMenu)
	warningScreen.show()
	await VNMain.fade(warningScreen, true)
	inGameMenu.hide()

func _on_cancel_button_pressed():
	await VNMain.fade(warningScreen)
	warningScreen.hide()

func _on_save_load_button_pressed():
	inGameMenu.hide()
	saveLoadMenu.show()
	saveLoadMenu.reload_slot_list()
	await VNMain.fade(saveLoadMenu, true)

func _on_saves_exit_button_pressed():
	if (visible):
		await VNMain.fade(saveLoadMenu)
		saveLoadMenu.hide()


func _on_show_story_pressed():
	VNMain.fade(inGameMenu)
	inGameMenu.hide()
	history.show()
	var count = historyBox.get_child_count()
	for i in range(count):
		historyBox.get_child(i).show()
	await VNMain.fade(history, true)


func _on_history_exit_button_pressed():
	var count = historyBox.get_child_count()
	for i in range(count):
		historyBox.get_child(i).hide()
	VNMain.fade(history)
	inGameMenu.show()
	await VNMain.fade(inGameMenu, true)
	history.hide()
	
func _on_text(text: Dictionary):
	var str: String = ""
	if (text.has("character") and text["character"] != null):
		var characterStr: String = text["character"];
		var character: DialogicCharacter = load(characterStr)
		str += character.get_display_name_translated() + ": ";
	var textStr: String = text["text"]
	str += textStr
	var duplicate: Label = historyLabel.duplicate()
	duplicate.hide()
	historyBox.add_child(duplicate)
	duplicate.text = str
	var idx: int = 10
	var data : Dictionary = {
		"idx": idx
	} 
	Dialogic.Save.save("save_%s" % idx, false, Dialogic.Save.ThumbnailMode.TAKE_AND_STORE, data)


func _on_quick_save_button_pressed():
	var idx: int = 11
	var data : Dictionary = {
		"idx": idx
	} 
	Dialogic.Save.save("save_%s" % idx, false, Dialogic.Save.ThumbnailMode.TAKE_AND_STORE, data)
	if (visible):
		await VNMain.fade(inGameMenu)
		inGameMenu.hide()


func _on_settings_exit_button_pressed():
	if (visible):
		await VNMain.fade(settings)
		settings.hide()


func _on_settings_button_pressed():
	VNMain.fade(inGameMenu)
	inGameMenu.hide()
	settings.show()
	await VNMain.fade(settings, true)


func _on_with_saving_button_pressed():
	var idx: int = 9
	var data : Dictionary = {
		"idx": idx
	} 
	Dialogic.Save.save("save_%s" % idx, false, Dialogic.Save.ThumbnailMode.TAKE_AND_STORE, data)
	get_tree().quit()
