class_name TileManager

var tile_size:int =32
enum state { DEAD, ALIVE,DEBUG }
var tilemap: TileMapLayer
var win:Window

var tile_info = {
	state.DEAD: {"source": 2, "alt": 0, "coor": Vector2i(0, 0)},
	state.ALIVE: {"source": 3, "alt": 0, "coor": Vector2i(0, 0)},
	state.DEBUG: {"source": 1, "alt": 1, "coor": Vector2i(0, 0)}
}

var outcome ={
	0: state.DEAD,
	1: state.ALIVE,
	2: state.DEBUG
}


func  place_cell(tile_state:state,tile_coor:Vector2i):
	var info =  tile_info[tile_state]
	self.tilemap.set_cell(
		tile_coor,
		info["source"],
		info["coor"],# altas coordinates,
		info["alt"]
		
	)

func remove_cell(tile_coor:Vector2i):
	self.place_cell(state.DEAD,tile_coor)
	

func remove_all_cells(): #removes alive cells
	var info = tile_info[state.ALIVE]
	var source = info["source"]
	var atlas_coor = info["coor"]
	var alt_tile =  info["alt"]
	
	var coords =  self.tilemap.get_used_cells_by_id(source,atlas_coor,alt_tile)
	for c in coords:
		self.place_cell(state.DEAD,c)

func alive_cells():
	var info = tile_info[state.ALIVE]
	var source = info["source"]
	var atlas_coor = info["coor"]
	var alt_tile =  info["alt"]
	
	var coords =  self.tilemap.get_used_cells_by_id(source,atlas_coor,alt_tile)
	return coords
	

func  iter(dim:Vector2i):
	var all_pos =[ ]  #n^2
	for i in range(dim.x+1):
		for j in range(dim.y+1):
			all_pos.append(Vector2i(i,j))
	return all_pos
	
	

func get_screen_dim():

	var screen_dim =round(self.tilemap.get_viewport().get_visible_rect().size)  ## visible screen part #this can be null oh well
	
	#var x = int(screen_dim.x)
	#var y  =int(screen_dim.y)
	
	#var adjusted_screen =  Vector2i( x- x%tile_size, y-y%tile_size)
	
	var screen_dim_map =  self.tilemap.local_to_map(screen_dim) #turning the global position into tile coordinat
	
	return screen_dim_map
	


func _init(tilemap:TileMapLayer) -> void:
	self.tilemap =tilemap
	var screen_dim_map:Vector2i
	screen_dim_map =self.get_screen_dim()
	
	
	
	var coors = self.iter(screen_dim_map)
	
	
	

	#setting the tiles to be black initialy
	for  c in coors:
		self.place_cell(state.DEAD,c)
	
func on_screen_resize():
	
	var screen_dim_map =  self.get_screen_dim()
	
	var coors = self.iter(screen_dim_map)
	for c in coors:
		if tilemap.get_cell_source_id(c) ==-1: # means when source ==-1 -> empty cell
			self.place_cell(state.DEAD,c)

func generate_neigh(coor:Vector2i):
	var sauce = self.tilemap.get_surrounding_cells(coor)
	var up = sauce[3]
	var down = sauce[1]
	
	var up_right =  up +Vector2i(1,0)
	var up_left = up +Vector2i(-1,0)
	
	var down_right =  down +Vector2i(1,0)
	var down_left = down +Vector2i(-1,0)
	
	var payload =[ up_left,up_right,down_right,down_left]
	sauce.append_array(payload)
	
	return sauce
	
	

	
func posmodus(coor:Vector2i):
	var dim =self.get_screen_dim()
	var xmax = dim.x
	var ymax = dim.y
	
	
	var x_i  = posmod(coor.x,xmax)
	var y_i =  posmod(coor.y,ymax)
	
	var pack = Vector2i(x_i,y_i)
	return pack
	

func wrapper(coors:Array[Vector2i]):
	var dim = get_screen_dim()
	var xmax = dim.x
	var ymax = dim.y
	
	var processed =[]
	
	for c in coors:
		var pack = posmodus(c)
		
		processed.append(pack)
		
	return processed
	
	

func check_status(coor:Vector2i):
	""" #    Any live cell with fewer than two live neighbours dies, as if by underpopulation.
		#    Any live cell with two or three live neighbours lives on to the next generation.
		#    Any live cell with more than three live neighbours dies, as if by overpopulation.
		#   Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction."""
	
	
	coor = posmodus(coor)
	var count =0
	var neighours = self.generate_neigh(coor)
	var processed =  self.wrapper(neighours)

	
	var cell_type =   self.tilemap.get_cell_source_id(coor)
	var source_alive =tile_info[state.ALIVE]["source"]
	var source_debug = tile_info[state.DEBUG]["source"]
	
	
	var bounds =  get_screen_dim()
	for neig in processed:
		
		if  self.tilemap.get_cell_source_id(neig)==source_alive:
			count+=1
	
	if cell_type == source_alive:
		if count < 2 or count > 3:
			return 0
		return 1
	else:
		if count==3:
			return 1
		return 0
		
func can_i_see(bounds:Vector2i, coor:Vector2i):
	if coor.x < bounds.x  and coor.y <bounds.y:
		return true
	return false
	

func  keep_it_tidy():
	var screen_dim = self.get_screen_dim()
	var coors = self.tilemap.get_used_cells()
	for c in coors:
		var ot = self.can_i_see(screen_dim,c)
		if not ot:
			self.tilemap.erase_cell(c)
	
func  update_field():
	var next_states ={}
	var coors = self.tilemap.get_used_cells()
	
	
	for c in coors:
		var result = check_status(c)
		next_states[c] =result
		
	for  c in next_states:
		var state_value = next_states[c]
		var state_type = outcome[state_value]
		place_cell(state_type,c)
		
		
	
		
	
	
	
	
	
	

	


#debug functions
func what_does_get_surrounding_cell_do(coor:Vector2i):
	var sauce = self.tilemap.get_surrounding_cells(coor)
	var up = sauce[3]
	var down = sauce[1]
	
	var up_right =  up +Vector2i(1,0)
	var up_left = up +Vector2i(-1,0)
	
	var down_right =  down +Vector2i(1,0)
	var down_left = down +Vector2i(-1,0)
	
	
	var payload =[ up_left,up_right,down_right,down_left]
	sauce.append_array(payload)
	
	
	
	
	for i in sauce:
		self.place_cell(state.DEBUG,i)
	
	
	
func set_win(window:Window):
	self.win = window
	

func get_screen_dim_small():
	var screen_dim =self.win.get_visible_rect().size 
	var screen_dim_map =  self.tilemap.local_to_map(screen_dim)
	#var corrected = screen_dim_map-Vector2i(0,3)# leaving room for ui
	
	return  screen_dim_map
	

func on_resize_small_win():
	var screen_dim_map = self.get_screen_dim_small()
	var coors = self.iter(screen_dim_map)
	
	for c in coors:

		if tilemap.get_cell_source_id(c) ==-1: # means when source ==-1 -> empty cell
			self.place_cell(state.DEAD,c)
	
	
	
			
		
		
	


			
	
	
	
	
	
	
	
	
	
	
	
	
