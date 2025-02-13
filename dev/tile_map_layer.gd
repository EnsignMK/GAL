extends  Node2D




var utils: TileManager

var mouse_pos =Vector2i(0,0)
var update_speed =0.3 # sec
var update_copy =0.3
var cn=0
var pause =true
var ps =false
var previews:Array
var submenus:Array[PopupMenu]

var store:Array[TileMapPattern]
var editor =load("res://scenes/bound.tscn")
var move_around =false
var current_pattern:TileMapPattern

# Called when the node enters the scene tree for the first time.
@onready var tilemap: TileMapLayer = $TileMapLayer
@onready var play: Button = $Control/HBoxContainer/Button
@onready var delete_all: Button = $Control/HBoxContainer/Button2
@onready var menu_button: MenuButton = $Control/MenuButton
@onready var texture_rect: TextureRect = $TextureRect

const PATTERN_MANGER = preload("res://scenes/pattern_manger.tscn")






	
func _ready() -> void:
	LoadPatternNames()
	LoadPreviews()

	
	get_tree().get_root().size_changed.connect(screen_on_resize)
	

	utils = TileManager.new(tilemap)
	play.text ="start"
	
	

	menu_button.get_popup().add_item("create custom pattern+")
	menu_button.get_popup().index_pressed.connect(on_pattern_name_pressed)
	
	
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_around:
		texture_rect.show()
		texture_rect.position = get_global_mouse_position()
		
		
	cn+=delta
	if (cn>update_speed):
		cn=0
		if not pause:
			utils.update_field()
	


func _input(event: InputEvent) -> void:
	
	
	if event.is_action_pressed("pause"):
		pause =!pause
		if pause:
			play.text ="start"
			play.button_pressed =false
		
		else:
			play.text ="pause"
			play.button_pressed =true
			
	if event.is_action_pressed("click"):

		var mouse_pos = tilemap.local_to_map(get_global_mouse_position())
		var local_mouse_pos = tilemap.to_local(get_global_mouse_position())
		var tile_pos = tilemap.local_to_map(local_mouse_pos)
		
		if tilemap.get_cell_source_id(mouse_pos)!=-1:
			if move_around:
				move_around =false
				if current_pattern:
					tilemap.set_pattern(tile_pos,current_pattern)
				current_pattern =null
				texture_rect.hide()
			else:
			
				utils.place_cell(utils.state.ALIVE,mouse_pos)
	
		
	if event.is_action("delete"):
		#who_is_focused(submenus)
		
		
		var mouse_pos = tilemap.local_to_map(get_global_mouse_position())
		if tilemap.get_cell_source_id(mouse_pos)!=-1:
			utils.remove_cell(mouse_pos)

	
			
		
		#var sauce =get_cell_tile_data(mouse_pos)
		#sauce.set_modulate(Color(0.486275, 0.988235, 0, 1)) #lawn green 
		#utils.remove_cell(self,mouse_pos)
		#pause =true
		#utils.debug(self)

	
	
	if event.is_action_pressed("delete_all"):
		utils.remove_all_cells()
	
	
		
func screen_on_resize(): # check_status is the culprit
	
	utils.on_screen_resize()
	utils.keep_it_tidy()


func _on_h_slider_value_changed(value: float) -> void:
	update_speed = 0.3
	var frac =  1 -value/100
	update_speed =frac*update_speed


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		play.text ="pause"
		pause =false
		#play.button_pressed = false
		play.release_focus()
	else:
		play.text ="start"
		pause =true
		play.release_focus()


func _on_delete_all(toggled_on: bool) -> void:
	if toggled_on:
		utils.remove_all_cells()
		delete_all.button_pressed = false
		delete_all.release_focus()
		
	
		
		#utils.remove_all_cells()
	if not toggled_on:
		print(delete_all.button_pressed)
		#delete_all.toggle_mode =true
		
		
####### menu button logic for pattern


func LoadPreviews():
	var path_preview ="res://previews/"
	var current_previews = DirAccess.get_files_at(path_preview)
	
	for p in  current_previews:
		if p.get_extension()=="tres":
			var full_path = path_preview+p
			var image = load(full_path)
			previews.append(image)
			
			
func LoadPatternNames():
	var current_patterns = DirAccess.get_files_at("res://patterns/")
	var path ="res://patterns/"
	
	
	for j in current_patterns:
		menu_button.get_popup().add_item(j.get_basename())
		
		var full_path =path+j
		store.append(load(full_path))
		

func on_pattern_name_pressed(id:int):
	var item_count = menu_button.get_popup().get_item_count()
	if id ==item_count-1:
		if editor:
			get_tree().change_scene_to_packed(editor)
	
	else:
	
		var loaded_pattern =store[id]
		var image = previews[id]
		fill_the_tecture(image)
		move_around =true
		current_pattern =loaded_pattern

		
		
		
func fill_the_tecture(image:Image):
	var texture=ImageTexture.create_from_image(image)
	texture_rect.texture =texture


func _on_manage_pressed() -> void:
	if PATTERN_MANGER:
		get_tree().change_scene_to_packed(PATTERN_MANGER)
		
