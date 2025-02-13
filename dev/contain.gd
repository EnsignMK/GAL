extends PanelContainer

var utils:TileManager
var pat:PatternManager
@onready var tilemap_editor: TileMapLayer = $TileMapLayer
@onready var save: Button = $"../ButtonHolder/HBoxContainer/Save"
@onready var clear: Button = $"../ButtonHolder/HBoxContainer/clear"
var  SAVEFILE = load("res://scenes/savefile.tscn")
var GAME = load("res://scenes/game.tscn")
const ALIVE_TILE_IMG = preload("res://tiles_pic/blue_border.png")

func create_preview_pattern1(pattern:TileMapPattern,name:String):
	var tilesize =32  # make sure you know what dimension your tiles are in the tilemap.
	var used_cells =  pattern.get_used_cells() 
	var dim =  pattern.get_size()*tilesize #turns tilemap coordinates into pixels
	
	
	var img =Image.create_empty(dim.x,dim.y,false,Image.Format.FORMAT_RGBA8)
	var small_image:Image =  ALIVE_TILE_IMG.get_image()  # fetches a preloaded tile image
	small_image.convert(Image.Format.FORMAT_RGBA8)  #it's import that they are the same format
	
	var path ="res://previews/"+str(name)+".tres"
	for u in used_cells:
		var coord = u*tilesize
		img.blit_rect(small_image,small_image.get_used_rect(),coord) #basically paste the small image inside the larger one 
	ResourceSaver.save(img,path)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_tree_string_pretty())
	utils =TileManager.new(tilemap_editor)
	self.resized.connect(ts)
	add_child(SAVEFILE.instantiate())
	get_child(-1).hide()
	GlobalSignal.save_pattern_name.connect(text_from_save)

	
	


func create_preview_pattern(pattern:TileMapPattern, name:String):
	var tilesize = 32  # Tile size in pixels
	var used_cells = pattern.get_used_cells()  # Get all used cells from the pattern
	var dim = pattern.get_size() * tilesize  # Convert tilemap dimensions to pixels
	
	# Create an empty image with RGBA format
	var img = Image.create_empty(dim.x, dim.y, false, Image.Format.FORMAT_RGBA8)  
	
	# Get the image from the preloaded resource
	var small_image:Image = ALIVE_TILE_IMG.get_image()  
	# Ensure the small image uses the same format
	small_image.convert(Image.Format.FORMAT_RGBA8)  
	
	#(make sure you have created the previews folder!)
	var path = "res://previews/" + str(name) + ".tres"  # Set the file path for the preview image 
	for u in used_cells:
		# Calculate the pixel coordinate for each cell
		var coord = u * tilesize  
		 # Paste the small image onto the main image at the calculated coordinate
		img.blit_rect(small_image, small_image.get_used_rect(), coord) 
	 # Save the composed image to the specified path
	ResourceSaver.save(img, path)
	#img.save_png("C:/Users/build/Documents/" +name+".png")
	

	


	
	
	
	
func ts():
	utils.on_screen_resize()
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var mouse_pos = tilemap_editor.local_to_map(event.position) -Vector2i(0,3) #offset
		if tilemap_editor.get_cell_source_id(mouse_pos)!=-1:
			utils.place_cell(utils.state.ALIVE,mouse_pos)
	if event.is_action_pressed("delete"):
		var mouse_pos = tilemap_editor.local_to_map(event.position) -Vector2i(0,3) #offset
		if tilemap_editor.get_cell_source_id(mouse_pos)!=-1:
			utils.remove_cell(mouse_pos)
			
		
	if event.is_action_pressed("delete_all"):
		utils.remove_all_cells()


func _on_clear_pressed() -> void:
	utils.remove_all_cells()
	clear.release_focus()


func _on_save_pressed() -> void:
	var out =utils.alive_cells()
	if out and (len(out)>1):
		get_child(-1).show()
	save.release_focus()
	
func _on_button_pressed() -> void:
	print("dummt works")
	var pe = load("res://patterns/pi.tres")
	tilemap_editor.set_pattern(Vector2i(10,10)-Vector2i(0,3),pe)
	
func text_from_save(name:String):
	print("succesful name transfer")
	print(name)
	
	var out =utils.alive_cells()
	if out:
		var pattern =  tilemap_editor.get_pattern(out)
		var path = "res://patterns/"+ str(name)+".tres"
		ResourceSaver.save(pattern,path)
		print("saved! name")
		create_preview_pattern(pattern,name)



func _on_back_pressed() -> void:
	if GAME:
		get_tree().change_scene_to_packed(GAME)
	
	
