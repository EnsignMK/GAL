extends TileMapLayer

var utils: Utils2
var old_dim=0
var mouse_pos =Vector2i(0,0)
# Called when the node enters the scene tree for the first time.
@onready var button: Button = $"../Button"

func _ready() -> void:
	utils =Utils2.new(self) #override over util class for specific issue handeling check fancy_utils gd
	get_tree().get_root().size_changed.connect(screen_on_resize)
	old_dim = get_viewport().get_visible_rect().size




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var mouse_pos = local_to_map(get_global_mouse_position())-Vector2i(0,1)
		utils.place_cell(self,utils.state.ALIVE,mouse_pos)
	if event.is_action("delete"):
		var mouse_pos = local_to_map(get_global_mouse_position())-Vector2i(0,1)
		utils.remove_cell(self,mouse_pos)
	
	if event.is_action_pressed("delete_all"):
		utils.remove_all_cells(self)
		
func screen_on_resize():
	var new_dim = get_viewport().get_visible_rect().size
	
	var old_area = utils.area(old_dim) #screen areas mind you
	var new_area =  utils.area(new_dim)
	
	if new_area>old_area:
		var bt_ps = map_to_local(button.global_position)
		utils.refresh_pos(self,bt_ps)
		old_dim =new_dim


		


	
