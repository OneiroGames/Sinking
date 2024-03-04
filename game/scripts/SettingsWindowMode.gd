extends MenuButton

func _ready():
	get_popup().connect("id_pressed", _on_MenuButton_item_selected)

func _on_MenuButton_item_selected(id):
	match id:
		0:
			var wind: Window = get_window();
			wind.mode = Window.MODE_WINDOWED
		1:
			var wind: Window = get_window();
			wind.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
