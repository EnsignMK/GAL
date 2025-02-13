extends MenuBar

var ogha = preload("res://scenes/bound.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pattern_id_pressed(id: int) -> void:
	if id ==2:
		var woke =ogha.instantiate()
		
		get_tree().get_root().add_child(woke)
		release_focus()
		
		
