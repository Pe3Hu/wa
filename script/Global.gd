extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_scene()
	init_font()


func init_arr() -> void:
	arr.craft = ["alchemy"]
	arr.sense = ["vision", "olfaction", "hearing"]
	arr.inspection = ["approximately", "keenly", "hint"]
	
	arr.hint =["fog", "stench", "noise", "lock", "key"]
	arr.density =["failure", "success"]
	arr.resource =["beast", "tree", "flower", "ore", "gem", "sand"]
	


func init_num() -> void:
	num.index = {}
	num.index.god = 0


func init_dict() -> void:
	init_direction()
	init_corner()
	init_craft()
	
	init_sense()
	init_terrain()


func init_direction() -> void:
	dict.direction = {}
	dict.direction.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.direction.linear2 = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.direction.diagonal = [
		Vector2i( 1,-1),
		Vector2i( 1, 1),
		Vector2i(-1, 1),
		Vector2i(-1,-1)
	]
	dict.direction.zero = [
		Vector2i( 0, 0),
		Vector2i( 1, 0),
		Vector2i( 1, 1),
		Vector2i( 0, 1)
	]
	dict.direction.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	dict.direction.windrose = []
	
	for _i in dict.direction.linear2.size():
		var direction = dict.direction.linear2[_i]
		dict.direction.windrose.append(direction)
		direction = dict.direction.diagonal[_i]
		dict.direction.windrose.append(direction)


func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [4]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2 * PI * _i / corners_ - PI / 2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex


func init_craft() -> void:
	dict.dice = {}
	dict.dice.craft = {}
	dict.dice.craft["alchemy"] = {}
	
	for value in range(1, 6, 1):
		dict.dice.craft["alchemy"][value] = 1


func init_sense() -> void:
	dict.sense = {}
	dict.sense.title = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/wa_sense.json"
	var array = load_data(path)
	
	for sense in array:
		var data = {}
		
		for key in sense:
			if !exceptions.has(key):
				data[key] = sense[key]
		
		dict.sense.title[sense.title] = data


func init_terrain() -> void:
	dict.terrain = {}
	dict.terrain.title = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/wa_terrain.json"
	var array = load_data(path)
	
	for terrain in array:
		var data = {}
		
		for key in terrain:
			if !exceptions.has(key):
				data[key] = terrain[key]
		
		dict.terrain.title[terrain.title] = data


func init_scene() -> void:
	scene.token = load("res://scene/0/token.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	scene.mainland = load("res://scene/2/mainland.tscn")
	
	scene.dice = load("res://scene/3/dice.tscn")
	scene.facet = load("res://scene/3/facet.tscn")
	
	scene.inspection = load("res://scene/4/inspection.tscn")
	
	


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(vec.size.sixteen)
	
	vec.size.token = Vector2(32, 32)
	vec.size.couple = Vector2(vec.size.token.x, vec.size.token.y) * 0.75
	
	var n = 6
	vec.size.mark = Vector2(vec.size.token) * 0.75
	vec.size.power = Vector2(vec.size.token) * 0.75
	vec.size.facet = vec.size.mark + vec.size.power * 0.75
	vec.size.encounter = Vector2(vec.size.facet.x * (2 * n + 1), vec.size.facet.y * n)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.card = {}
	color.card.selected = {}
	color.card.selected[true] = Color.from_hsv(160 / h, 0.4, 0.7)
	color.card.selected[false] = Color.from_hsv(60 / h, 0.2, 0.9)
	
	color.card.profit = {}
	color.card.profit[true] = Color.from_hsv(120 / h, 0.4, 0.7)
	color.card.profit[false] = Color.from_hsv(0 / h, 0.2, 0.9)


func init_font():
	dict.font = {}
	dict.font.size = {}
	dict.font.size["basic"] = 18
	dict.font.size["aspect"] = 24
	dict.font.size["cost"] = 18
	dict.font.size["season"] = 18
	dict.font.size["phase"] = 18
	dict.font.size["moon"] = 18


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
