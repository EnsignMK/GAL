extends ItemList
@onready var accept_dialog: AcceptDialog = $"../AcceptDialog"
var GAME = load("res://scenes/game.tscn")

var passer:int
var saved_patterns ={}
var to_be_deleted:Array[String]


func remove_file(path:String):
	DirAccess.remove_absolute(path)
	
func LoadPatternNames():
	var current_patterns = DirAccess.get_files_at("res://patterns/")
	var path ="res://patterns/"
	var path_previews ="res://previews/"
	
	for j in current_patterns:
		var full_path =path+j
		var full_path_pre = path_previews+j
		saved_patterns[j.get_basename()] =[full_path,full_path_pre]
		
		
		


func _ready() -> void:
	LoadPatternNames()
	for i in saved_patterns:
		add_item(i)
	
	
	
	
	
func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	accept_dialog.set_text("delete: " + get_item_text(index)+"?")
	passer =index
	accept_dialog.show()
	
func _on_accept_dialog_confirmed() -> void:
	var del =saved_patterns[get_item_text(passer)]
	for d in del:
		remove_file(d)
	remove_item(passer) #remove it from the item list
	

func _on_accept_dialog_canceled() -> void:
	accept_dialog.hide()


func _on_button_pressed() -> void:
	if GAME:
		get_tree().change_scene_to_packed(GAME)
	
