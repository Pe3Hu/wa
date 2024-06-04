extends MarginContainer


#region vars
@onready var mark = $Mark
@onready var power = $Power

var dice = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	dice = input_.dice
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = input_.type
	input.subtype = "empty"
	input.value = input_.value
	power.set_attributes(input)
	power.custom_minimum_size = Vector2(Global.vec.size.power)
	
	input.erase("power")
	
	for type in Global.arr:
		if input_.type == "facet":
			if Global.arr[type].has(input_.subtype):
				input.type = type
		else:
			break
	
	input.subtype = input_.subtype
	mark.set_attributes(input)
	mark.custom_minimum_size = Vector2(Global.vec.size.mark)
	
	
	custom_minimum_size = Vector2(Global.vec.size.facet)
#endregion


func get_power_value() -> int:
	return power.get_value()
