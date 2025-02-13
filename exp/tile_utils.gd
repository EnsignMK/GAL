
class_name Utils

#I can use get_used_rect() to update the states for the tilemapLayers!!
static var tile_size:int =32
enum state { DEAD, ALIVE,DEBUG }

static var tile_info = {
	state.DEAD: {"source": 2, "alt": 0, "coor": Vector2i(0, 0)},
	state.ALIVE: {"source": 3, "alt": 0, "coor": Vector2i(0, 0)},
	state.DEBUG: {"source": 1, "alt": 1, "coor": Vector2i(0, 0)}
}
static var outcome ={
	0: state.DEAD,
	1: state.ALIVE,
	2: state.DEBUG
}
func _init(tilemap:TileMapLayer) -> void:
	var dim =  tilemap.get_viewport().get_visible_rect().size
	dim =Vector2i(round(dim.x / tile_size), round(dim.y / tile_size))

	
	var x = dim[0]
	var y = dim[1]
	
	for i in range(x+1):
		for j in range(y+1):
			var tile_coor =  Vector2i(i,j)
			place_cell(tilemap,state.DEAD,tile_coor)
	
	
	
	
	
	
static  func  place_cell(tilemap:TileMapLayer,tile_state:state,tile_coor:Vector2i):

	var info =  tile_info[tile_state]
	tilemap.set_cell(
		tile_coor,
		info["source"],
		info["coor"],# altas coordinates,
		info["alt"]
		
	)
	
static func remove_cell(tilemap:TileMapLayer,tile_coor:Vector2i):
	place_cell(tilemap,state.DEAD,tile_coor)
	
static func remove_all_cells(tilemap:TileMapLayer): #removes alive cells
	var info = tile_info[state.ALIVE]
	var source = info["source"]
	var atlas_coor = info["coor"]
	var alt_tile =  info["alt"]
	
	var coords =  tilemap.get_used_cells_by_id(source,atlas_coor,alt_tile)
	for c in coords:
		place_cell(tilemap,state.DEAD,c)

static  func normalize(coord:Vector2i):
	var xnorm =abs(round(coord.x/tile_size))+1
	var ynorm =  abs(round(coord.y/tile_size))+1
	return Vector2i(xnorm,ynorm)
	
	
static func get_bounds(tilemap:TileMapLayer):
	return tilemap.local_to_map(tilemap.get_viewport().get_visible_rect().size)

static func mod(coor:Vector2i, bounds:Vector2i):
	var xmax = bounds[0]
	var ymax = bounds[1]
	
	return Vector2i(posmod(coor.x , xmax),  posmod(coor.y ,ymax))
	
static func wrapper(tilemap:TileMapLayer,tile_coor:Vector2i):
	var bounds  =get_bounds(tilemap)
	var patch_coor = mod(tile_coor,bounds)
	return patch_coor
	
	
	
static func check_status(tilemap:TileMapLayer,tile_coor:Vector2i):
	""" #    Any live cell with fewer than two live neighbours dies, as if by underpopulation.
		#    Any live cell with two or three live neighbours lives on to the next generation.
		#    Any live cell with more than three live neighbours dies, as if by overpopulation.
		#   Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction."""
	#tile_coor =wrapper(tilemap,tile_coor)
	var x=tile_coor[0]
	var y =tile_coor[1]
	
	var count =0
	
	var top = Vector2i(x,y-1)
	var bot = Vector2i(x,y+1)
	var right =  Vector2i(x+1,y)
	var left = Vector2i(x-1,y)
	
	var top_left = Vector2i(x-1, y-1)
	var top_right = Vector2i(x+1, y-1)
	var bot_left = Vector2i(x-1, y+1)
	var bot_right = Vector2i(x+1, y+1)
	var neighbours= [top, bot, left, right ,top_left, top_right, bot_left, bot_right]
	
	var cell_type =   tilemap.get_cell_source_id(tile_coor)
	var source_alive =tile_info[state.ALIVE]["source"]
	var source_debug = tile_info[state.DEBUG]["source"]
	
	
	for neigh in neighbours:
		var warp = wrapper(tilemap,neigh)
		
		if  tilemap.get_cell_source_id(warp)==source_alive or  (cell_type == source_debug) :
			count+=1
	
		
		
			
	if cell_type == source_alive or (cell_type == source_debug):
		if count < 2 or count > 3:
			return 0
		return 1
	else:
		if count==3:
			return 1
		return 0
	

static  func update_field(tilemap:TileMapLayer):
	var bounder = get_bounds(tilemap)
	var coords =  looper(bounder)
	var next_states ={}
	for coor in coords:
		var out =  check_status(tilemap,coor)
		next_states[coor]=out
	
	for coor in next_states:
		var state_value = next_states[coor]
		var state_type = outcome[state_value]
		place_cell(tilemap,state_type,coor)
	
	 #for coor in next_states:
	   # if coor.x >= 0 and coor.y >= 0:  # Ensure coordinates are within bounds
		   # var state_value = next_states[coor]
			#var state_type = outcome[state_value]
			#place_cell(tilemap, state_type, coor)
	
		
		
	
			
		
		
		
static func looper(z:Vector2i):
	var x = z[0]
	var y = z[1]
	
	
	var can =[]
	for i in range(x+1):
		for j in range(y+1):
			can.append(Vector2i(i,j))
	return can


	
	
static  func area(coord:Vector2i):
	return abs(coord.x* coord.y)

static func refresh(tilemap:TileMapLayer):
	var dim = tilemap.local_to_map(tilemap.get_viewport().get_visible_rect().size)
	var cn =0
	var coors  =looper(dim)
	
	for c in coors:
		if tilemap.get_cell_source_id(c) ==-1:
			
			place_cell(tilemap,state.DEAD,c)
	
	#update_field(tilemap)
static func alive_cells(tilemap:TileMapLayer):
	var info = tile_info[state.ALIVE]
	var source = info["source"]
	var atlas_coor = info["coor"]
	var alt_tile =  info["alt"]
	
	var coords =  tilemap.get_used_cells_by_id(source,atlas_coor,alt_tile)
	return coords
	
static func debug(tilemap:TileMapLayer):
	#var dim =tilemap.get_used_rect().size #encloses are cells even the nonvisible ones!
	var dim = get_bounds(tilemap)
	var coors  =looper(dim)
	
	for c in coors:
		place_cell(tilemap,state.ALIVE,c)
	
	
	


	


	

		

	
	

	

	
	
