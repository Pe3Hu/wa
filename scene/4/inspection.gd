extends MarginContainer


#region vars
@onready var approximately = $Dices/Approximately
@onready var keenly = $Dices/Keenly
@onready var hint = $Dices/Hint

var encounter = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	encounter = input_.encounter
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_dices()


func init_dices() -> void:
	for kind in Global.arr.inspection:
		var dice = get(kind)
		
		var input = {}
		input.proprietor = self
		input.kind = kind
		dice.set_attributes(input)
