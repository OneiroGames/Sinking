extends Control

func _on_already_read_event() -> void:
	show()

func _on_not_read_event() -> void:
	hide()
