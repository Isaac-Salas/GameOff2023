extends Node

@onready var text_box_scene = preload("res://UI/TextBox/dialogue_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0 

var text_box
var text_box_position: Vector3
var is_dialog_active = false
var can_advance_line = false

func start_dialog(position:Vector3, lines: Array[String]):
	if is_dialog_active:
		return
	dialog_lines = lines
	text_box_position = position + Vector3(0, 5, -2)
	_show_text_box()
	is_dialog_active = true
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box = text_box.get_node("SubViewport/TextBox")
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box.get_parent().get_parent())
	text_box.get_parent().get_parent().global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event):
	if event.is_action_pressed ("Interact") && is_dialog_active && can_advance_line:
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			return
		_show_text_box()
