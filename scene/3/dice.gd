extends MarginContainer


#region vars
@onready var bg = $BG
@onready var facets = $BG/Facets
@onready var timer = $Timer

var proprietor = null
var kind = null
var tween = null
var pace = null
var tick = null
var time = null
var counter = 0
var window = 1
var skip = true
var anchor = null
var temp = true
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	kind = input_.kind
	
	init_basic_setting()


func init_basic_setting() -> void:
	time = Time.get_unix_time_from_system()
	anchor = Vector2(0, -Global.vec.size.facet.y)
	init_facets()
	shuffle_facets()
	update_size()
	reset()
	#skip_animation()


func init_facets() -> void:
	if !Global.arr.inspection.has(kind):
		for value in Global.dict.dice.craft[proprietor.craft]:
			for _i in Global.dict.dice.craft[proprietor.craft][value]:
				add_facet(proprietor.craft, value)
	else:
		var encounter = proprietor.encounter
		
		match kind:
			"approximately":
				for type in encounter.density:
					for _i in encounter.density[type]:
						add_facet(type, 1)
			"keenly":
				var description = Global.dict.terrain.title[encounter.terrain]
				
				for type in description:
					for _i in description[type]:
						add_facet(type, 1)
			"hint":
				for type in encounter.interferences:
					for _i in encounter.interferences[type]:
						add_facet(type, 1)


func add_facet(subtype_: String, value_: int) -> void:
	var input = {}
	input.dice = self
	input.type = "facet"
	input.subtype = subtype_
	input.value = value_
	
	var facet = Global.scene.facet.instantiate()
	facets.add_child(facet)
	facet.set_attributes(input)


func update_size() -> void:
	var vector = Global.vec.size.facet#Vector2(facets.get_child(0).size)
	vector.y *= window
	custom_minimum_size = vector


func roll() -> void:
	if !proprietor.fixed:
		if skip:
			skip_animation()
			proprietor.dice_stopped(self)
		else:
			timer.start()
	
	reset()


func reset() -> void:
	shuffle_facets()
	pace = 30
	tick = 0
	facets.position.y = -Global.vec.size.facet.y * 1
	var facet = facets.get_child(facets.get_child_count() - 1)
	var value = facet.get_power_value()
	flip_to_value(value)


func shuffle_facets() -> void:
	var temps = []
	
	for facet in facets.get_children():
		facets.remove_child(facet)
		temps.append(facet)
	
	temps.shuffle()
	
	for facet in temps:
		facets.add_child(facet)


func decelerate_spin() -> void:
	tick += 1
	var limit = {}
	limit.min = 1.0
	limit.max = max(limit.min, 10.0 - tick * 0.15)
	#start 100 min 1.0 max 10.0 step 0.1 stop 10 = 2.2 sec
	Global.rng.randomize()
	var gap = Global.rng.randf_range(limit.min, limit.max)
	pace -= gap
	var optimal = 0.1
	timer.wait_time = max(min(optimal, 1.0 / pace), optimal)


func _on_timer_timeout():
	var _time = 1.0 / pace
	
	if pace >= 1.5:
		tween = create_tween()
		tween.tween_property(facets, "position", Vector2(0, 0), _time).from(anchor)
		tween.tween_callback(pop_up)
		decelerate_spin()
	else:
		#print("end at", Time.get_unix_time_from_system() - time)
		proprietor.dice_stopped(self)


func pop_up() -> void:
	var facet = facets.get_child(facets.get_child_count() - 1)
	facets.move_child(facet, 0)
	
	if !skip:
		facets.position = anchor
		timer.start()


func skip_animation() -> void:
	var facet = facets.get_children().pick_random()
	flip_to_value(facet.get_power_value())


func flip_to_value(value_: int) -> void:
	for facet in facets.get_children():
		if facet.get_power_value() == value_:
			var index = facet.get_index()
			var step = 1 - index
			
			if step < 0:
				step = facets.get_child_count() - index + 1
			
			for _j in step:
				pop_up()
			
			return


func get_current_facet_value() -> int:
	var facet = facets.get_child(1)
	return facet.get_power_value()


func crush() -> void:
	proprietor.dices.remove_child(self)
	queue_free()
#endregion


func set_as_major() -> void:
	var facet = facets.get_child(1)
	facet.set_subtype("major")
