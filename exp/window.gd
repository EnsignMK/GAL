extends  Control


var utils:TileManager
# Called when the node enters the scene tree for the first time.

@onready var window: Window = $Window
@onready var tile: TileMapLayer = $Window/TileMapLayer
@onready var pattern: PopupMenu = $MenuBar/Pattern
var no:Vector2i = Vector2i(3,3)
@onready var camera_2d: Camera2D = $Window/TileMapLayer/Camera2D

func _ready() -> void:
	
	utils = TileManager.new(tile)
	utils.set_win(window)
	window.size_changed.connect(screen_on_resize)
	
	#camera_2d.Rect
		
	#feature add colors!
	#https://www.reddit.com/r/godot/comments/186fktw/tilemaps_modulating_single_tiles/

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func  screen_on_resize():
	utils.on_resize_small_win()
	#utils.no_zone(no)




func _on_window_close_requested() -> void:
	#pattern.release_focus()
	window.hide()
	
	#window.gui_release_focus()

	


func _on_window_window_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var mouse_pos =tile.local_to_map(event.global_position)
		utils.place_cell(utils.state.ALIVE,mouse_pos)
		
		#utils.what_does_get_surrounding_cell_do(mouse_pos)
	if event.is_action("delete"):
		
		var mouse_pos =tile.local_to_map(event.global_position)
		utils.remove_cell(mouse_pos)
		
			
	if event.is_action_pressed("delete_all"):
		utils.remove_all_cells()
