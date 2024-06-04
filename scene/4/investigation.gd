extends MarginContainer


#region vars
@onready var noise = $Hits/Noise
@onready var stench = $Hits/Stench
@onready var fog = $Hits/Fog
@onready var lock = $Hits/Lock
@onready var key = $Hits/Key

var encounter = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	encounter = input_.encounter
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_hints()


func init_hints() -> void:
	for type in Global.arr.hint:
		var token = get(type)
		
		var input = {}
		input.proprietor = self
		input.type = "hint"
		input.subtype = type
		input.value = 0
		token.set_attributes(input)
#endregion
