extends Control

@onready var wn =$Window
# Called when the nod$Windowe enters the scene tree for the first time.
func _ready() -> void:
	wn.popup()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_window_close_requested() -> void:
	print("???")
	wn.hide()
