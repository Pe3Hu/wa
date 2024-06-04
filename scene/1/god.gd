extends MarginContainer


#region vars

var pantheon = null
var planet = null
var opponents = []
var index = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.god = self
	
	index = int(Global.num.index.god)
	Global.num.index.god += 1
#endregion


func pick_opponent() -> MarginContainer:
	var opponent = opponents.pick_random()
	return opponent


func concede_defeat() -> void:
	planet.loser = self
