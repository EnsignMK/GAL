extends Window

@onready var save_pattern: Button = $SavePattern
@onready var line_edit: LineEdit = $LineEdit


func  get_text_length():
	line_edit.select_all()
	var length:int = len(line_edit.get_selected_text())
	line_edit.deselect()
	
	return length
	




func _on_save_pattern_pressed() -> void:
	var curr_len = get_text_length()
	if curr_len>1:
			#on_save_pattern.emit(line_edit.text)
			GlobalSignal.save_pattern_name.emit(line_edit.text)
			line_edit.clear()
			hide()

	

func _on_close_requested() -> void:
	line_edit.clear()
	hide()
	



	
	
