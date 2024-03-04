extends Control
class_name VNMain

@export var mainMenu: Control
@export var mainMenuPart: VBoxContainer
@export var inGameMenu: Control
@export var saveLoadMenu: SaveLoadMenu
@export var warningScreen: ColorRect
@export var history: Control
@export var settings: Control

@export var slider1: HSlider
@export var slider2: HSlider
@export var slider3: HSlider

var isAnim: bool = false

static func fade(node, fade_in:= false):
	var tween: Tween = node.create_tween().set_parallel()
	if fade_in:
		node.modulate = Color.TRANSPARENT
		tween.tween_property(node, 'modulate', Color.WHITE, 0.2)
	else:
		node.modulate = Color.WHITE
		tween.tween_property(node, 'modulate', Color.TRANSPARENT, 0.2)
	await tween.finished
	await node.get_tree().create_timer(0.3).timeout

func _ready():
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	if FileAccess.file_exists("user://settings.json"):
		var file = FileAccess.open("user://settings.json", FileAccess.READ)
		var read_data = file.get_as_text()
		var json = JSON.new()
		json.parse(read_data)
		var data = json.get_data()
		print(data)
		var master: float = data["master_volume"]
		var music: float = data["music_volume"]
		var sfx: float = data["sfx_volume"]
		var windowMode: int = data["window_mode"]
		print(master)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), sfx)
		get_window().mode = windowMode;
		
		slider1.value = master
		slider2.value = music
		slider3.value = sfx
		
		file.close()
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _exit_tree():
	var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	var dic = {
		"master_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")),
		"music_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
		"sfx_volume": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx")),
		"window_mode": get_window().mode
	}
	file.store_string(JSON.stringify(dic))
	file.close()
	

func _process(delta):
	#if (Input.is_action_pressed("skip")):
		#await get_tree().create_timer(0.5, false, false, true).timeout
		#Dialogic.handle_next_event()
		#await get_tree().create_timer(0.5, false, false, true).timeout
	
	if (Input.is_action_just_pressed("ui_cancel") and not isAnim):
		if (mainMenu.visible):
			if (saveLoadMenu.visible):
				mainMenuPart.show()
				VNMain.fade(mainMenuPart, true)
				isAnim = true
				await VNMain.fade(saveLoadMenu)
				saveLoadMenu.hide()
				isAnim = false
		else:
			if (!saveLoadMenu.visible and !warningScreen.visible and !history.visible and !settings.visible):
				if (inGameMenu.visible):
					isAnim = true
					await VNMain.fade(inGameMenu)
					inGameMenu.visible = false
					isAnim = false
				else:
					isAnim = true
					inGameMenu.visible = true
					await VNMain.fade(inGameMenu, true)
					isAnim = false
			if (settings.visible):
				isAnim = true
				await VNMain.fade(settings)
				settings.hide()
				isAnim = false
			if (history.visible):
				isAnim = true
				await VNMain.fade(history)
				history.hide()
				isAnim = false
			if (saveLoadMenu.visible):
				isAnim = true
				await VNMain.fade(saveLoadMenu)
				saveLoadMenu.hide()
				isAnim = false
			if (warningScreen.visible):
				isAnim = true
				await VNMain.fade(warningScreen)
				warningScreen.hide()
				isAnim = false

func _on_dialogic_signal(argument:String):
	if argument == "exit":
		get_tree().quit()
