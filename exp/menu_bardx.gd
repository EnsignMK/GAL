extends MenuBar
@onready var patterns: PopupMenu = $Patterns


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	patterns.add_item("test1")
	patterns.add_item("test2")
	patterns.add_item("sparta")
	var dx = PopupMenu.new()
	dx.name ="this_one"
	
	
	
	
	patterns.add_submenu_node_item("sparta",dx,0)
	#patterns.get_item_submenu_node(2).add_check_item("juicy")
	#patterns.id_pressed.connect(beast)
	#patterns.get_item_submenu_node(2).id_pressed.connect(breach)
	#patterns.get_item_submenu_node(2).add_check_item("juicy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func breach(id:int):
	print(" wer are pressing submenu")
func beast(id:int):
	print("different beast man")


func _on_patterns_id_focused(id: int) -> void:
	print("hello????")


func _on_patterns_id_pressed(id: int) -> void:
	print("peace my brother")


func _on_patterns_index_pressed(index: int) -> void:
	print("what are you???")
