extends MarginContainer


#region vars
@onready var alchemy = $VBox/Pools/Alchemy
@onready var investigation = $VBox/HBox/Investigation
@onready var inspections = $VBox/HBox/Inspections

var planet = null
var moon = null
var challenge = null
var terrain = null
var pools = []
var density = {}
var interferences = {}
#endregion


#region vars
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.encounter
	
	init_pools()
	#prepare_dices("alchemy")
	
	var input = {}
	input.encounter = self
	investigation.set_attributes(input)
	
	terrain = "forest"
	
	density.failure = 5
	density.success = 15
	
	interferences.noise = 4
	interferences.stench = 4
	interferences.fog = 4
	interferences.lock = 8
	interferences.key = 6
	
	add_inspection()


func init_pools() -> void:
	var input = {}
	input.encounter = self
	
	for craft in Global.arr.craft:
		input.craft = craft
		var pool = get(craft)
		pool.set_attributes(input)
#endregion


func prepare_dices(craft_: String) -> void:
	var pool = get(craft_)
	var dices = 0
	
	match craft_:
		"alchemy":
			dices = 3
	
	pool.add_dices(craft_, dices)


func roll_dices() -> void:
	for craft in Global.arr.craft:
		var pool = get(craft)
		pools.append(pool)
		
	for craft in Global.arr.craft:
		var pool = get(craft)
		pool.roll_dices()


func pool_stopped(pool_: MarginContainer) -> void:
	pools.erase(pool_)
	
	if pools.is_empty():
		struggle()
	
	#moon.follow_phase()


func reset() -> void:
	for craft in Global.arr.craft:
		var pool = get(craft)
		pool.reset()


func set_challenge(challenge_: Classes.Challenge) -> void:
	reset()
	challenge = challenge_
	
	#prepare_dices()
	roll_dices()


func struggle() -> void:
	var crafts = []
	crafts.append_array(Global.arr.craft)
	
	var order = []
	
	while !crafts.is_empty():
		if order.is_empty():
			order.append_array(crafts)
		
		var craft = order.pop_front()
		var pool = get(craft)
		
		if pool.dices.get_child_count() > 0:
			var dice = pool.dices.get_child(0)
			
			if dice.get_current_facet_value() > 0:
				find_victum(dice)
			else:
				crafts.erase(craft)
		else:
			crafts.erase(craft)


func find_victum(dice_: MarginContainer) -> void:
	var opponent = {}
	opponent.craft = Global.dict.craft.opponent[dice_.pool.craft]
	opponent.pool = get(opponent.craft)
	
	if opponent.pool.dices.get_child_count() > 0:
		opponent.dice = null
		
		for dice in opponent.pool.dices.get_children():
			if dice_.get_current_facet_value() > dice.get_current_facet_value():
				opponent.dice = dice
				break
		
		if opponent.dice != null:
			var kind = opponent.dice.kind
			challenge[opponent.craft].change_troop_value(kind, -1)
			opponent.dice.crush()
			print([dice_.pool.craft, dice_.kind, dice_.get_current_facet_value(), opponent.dice.kind, opponent.dice.get_current_facet_value()])
			dice_.crush()
	else:
		dice_.crush()



func add_inspection() -> void:
	var input = {}
	input.encounter = self
	
	var inspection = Global.scene.inspection.instantiate()
	inspections.add_child(inspection)
	inspection.set_attributes(input)
