extends Control

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_h_slider_2_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_h_slider_3_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), value)
