extends Control
class_name SaveLoadMenu

@export var mainMenu: Control
@export var saveButton: Button
@export var loadButton: Button
@export var savesGrid: Control
@export var selectedRect: ColorRect

var selectedButton: TextureButton

func reload_slot_list():
	var savesCount = savesGrid.get_child_count()
	var saves : Array[TextureButton]
	for i in range(savesCount):
		var btn = savesGrid.get_child(i);
		if (btn is TextureButton):
			saves.push_back(btn)
		
	var slotNames : Array = Dialogic.Save.get_slot_names()
	
	for slotName in slotNames:
		var slotInfo : Dictionary = Dialogic.Save.get_slot_info(slotName)
		var slotIdx : int = slotInfo.get("idx");
		saves[slotIdx].texture_normal = Dialogic.Save.get_slot_thumbnail(slotName)

func _process(delta):
	if (selectedButton == null):
		loadButton.disabled = true
		saveButton.disabled = true
		selectedRect.hide()

func _on_save_button():
	var idx: int = selectedButton.get_meta("idx") - 1
	var data : Dictionary = {
		"idx": idx
	} 
	Dialogic.Save.save("save_%s" % idx, false, Dialogic.Save.ThumbnailMode.TAKE_AND_STORE, data)
	reload_slot_list()
	pass

func _on_load_button():
	if (mainMenu.visible):
		VNMain.fade(mainMenu)
	await VNMain.fade(self)
	%IngameUI.enter_game()
	mainMenu.hide()
	hide()
	var idx: int = selectedButton.get_meta("idx") - 1
	Dialogic.Save.load("save_%s" % idx)
	pass
	
func _on_grid_button():
	var savesCount = savesGrid.get_child_count()
	for i in range(savesCount):
		var btn = savesGrid.get_child(i)
		if (btn is TextureButton and btn.is_pressed()):
			selectedRect.show()
			selectedButton = btn
			selectedRect.position = selectedButton.position;
			var btnIdx : int = selectedButton.get_meta("idx") - 1
			var slotNames : Array = Dialogic.Save.get_slot_names()
			for slotName in slotNames:
				var slotInfo : Dictionary = Dialogic.Save.get_slot_info(slotName)
				var slotIdx : int = slotInfo.get("idx");
				if (btnIdx == slotIdx):
					if (Dialogic.Save.get_slot_thumbnail(slotName) != null):
						loadButton.disabled = false
					else:
						loadButton.disabled = true
					break
				else:
					loadButton.disabled = true
			
			if (!%IngameUI.visible):
				saveButton.disabled = true
			else:
				saveButton.disabled = false
			return
