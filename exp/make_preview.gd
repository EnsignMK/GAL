extends Control
@onready var texture_rect: TextureRect = $TextureRect


var store:Array[TileMapPattern]
var play:TileMapPattern
const REDBUG = preload("res://tiles_pic/redbug.png")



func LoadPatternNames():
	var current_patterns = DirAccess.get_files_at("res://patterns/")
	var path ="res://patterns/"
	for j in current_patterns:
		var full_path =path+j
		store.append(load(full_path))



	
				
				
		

func in_range(arr:Array[Vector2i],point:Vector2i):
	for a in arr:
		var dm = a*32
		if point.x<=dm.x  and point.y<=dm.y:
			return true
	return false
	
	
	
		
func draw_me_an_image():
	var arr = store[0].get_used_cells()
	var dim = store[0].get_size() #this is it
	var tilesize =32
	var max_with =dim.x*tilesize
	var height = dim.y*tilesize
	var img =Image.create_empty(max_with,height,false,Image.Format.FORMAT_RGBA8)
	var small:Image = REDBUG.get_image()
	
	small.convert(Image.Format.FORMAT_RGBA8)

	
	
	
	for i in arr:
		var dx = i*32
		img.blit_rect(small,small.get_used_rect(),dx)
	


	var texture = ImageTexture.create_from_image(img)
	texture_rect.texture =texture
	img.save_png("res://previews/"+"test_preview.png")
	
			
		

		#for j in height:
			#img.set_pixel(i,j,Color.CRIMSON)
	#var texture = ImageTexture.create_from_image(img)
	#

	
	#
	
func _ready() -> void:
	LoadPatternNames()
	#print(texture_rect.get_id())
	draw_me_an_image()
	
	

func no_duplicates(arr:Array[Vector2i]):
	var result:Array[Vector2i]
	for a in arr:
		if a not in result:
			result.append(a)
	return result
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	pass
	
	
	
