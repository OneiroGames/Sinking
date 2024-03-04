extends Control

@export var inGameMenu: Control
@export var saveLoadMenu: SaveLoadMenu
@export var continueButton: Button
@export var newGameButton: Button
@export var loadButton: Button
@export var backButton: Button
@export var mainPart: VBoxContainer
@export var settings: Control

func _ready() -> void:
	open()

func open():
	saveLoadMenu.hide()
	%IngameUI.hide()
	show()
	continueButton.visible = !Dialogic.Save.get_latest_slot().is_empty()
	if continueButton.visible:
		continueButton.grab_focus()
	else:
		newGameButton.grab_focus()
	loadButton.visible = !Dialogic.Save.get_slot_names().is_empty()
	settings.hide()

func _on_dialogic_end() -> void:
	Dialogic.Save.set_latest_slot('')
	open()

func _on_menu_continue_pressed():
	display_button_ripple(continueButton)
	load_slot(Dialogic.Save.get_latest_slot())

func _on_new_game_pressed():
	display_button_ripple(newGameButton)
	await VNMain.fade(get_parent())
	Dialogic.start("start")
	Dialogic.timeline_ended.connect(_on_dialogic_end)
	hide()
	%IngameUI.enter_game()

func _on_load_pressed():
	mainPart.hide()
	saveLoadMenu.show()
	saveLoadMenu.reload_slot_list()
	await VNMain.fade(saveLoadMenu, true)

func load_slot(slot_name:String) -> void:
	await VNMain.fade(get_parent())
	Dialogic.Save.load(slot_name)
	if not Dialogic.timeline_ended.is_connected(_on_dialogic_end):
		Dialogic.timeline_ended.connect(_on_dialogic_end)
	hide()
	%IngameUI.enter_game()

func _on_back_pressed():
	display_button_ripple(backButton)
	await VNMain.fade(get_parent())
	get_tree().quit()

func display_button_ripple(button:CanvasItem):
	button.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	var btn = TextureRect.new();
	btn.size = button.size+Vector2(20,0)
	btn.position = -Vector2(20,0)/2
	btn.name = "Effect"
	btn.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	btn.texture = load("res://game/assets/ui/open.webp")
	btn.material = load("res://game/assets/misc/button_click_overlay.tres")
	
	button.add_child(btn)
	btn.material.set_shader_parameter('size', btn.size)
	btn.material.set_shader_parameter('circle_center', btn.get_local_mouse_position()/btn.size)
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn.material,"shader_parameter/time",1.0,0.5).from(0.0)
	await tween.finished
	button.get_child(0).queue_free()


func _on_saves_exit_button_pressed():
	if (!%IngameUI.visible):
		mainPart.show()
		VNMain.fade(mainPart, true)
		await VNMain.fade(saveLoadMenu)
		saveLoadMenu.hide()


func _on_settings_exit_button_pressed():
	if (!%IngameUI.visible):
		mainPart.show()
		VNMain.fade(mainPart, true)
		await VNMain.fade(settings)
		settings.hide()


func _on_settings_pressed():
	mainPart.hide()
	settings.show()
	await VNMain.fade(settings, true)
