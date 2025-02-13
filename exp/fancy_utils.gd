extends Utils
class_name Utils2

static func hello():
	print("I think this works??")
	
	





static  func  place_cell_pos(tilemap:TileMapLayer,tile_state:state,tile_coor:Vector2i,button_pos:Vector2i):
	if (button_pos!=tile_coor) or !(tilemap.get_cell_source_id(tile_coor)==-1):

		var info =  tile_info[tile_state]
		tilemap.set_cell(
			tile_coor,
			info["source"],
			info["coor"],# altas coordinates,
			info["alt"]
			
		)
		
static func refresh_pos(tilemap:TileMapLayer,button_pos:Vector2i):
	var dim = normalize(tilemap.get_viewport().get_visible_rect().size)
	var coors  =looper(dim)
	
	for c in coors:
			place_cell_pos(tilemap,state.DEAD,c,button_pos)
