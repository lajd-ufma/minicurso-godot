extends Node

var coins:int = 0
var current_level:String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_current_level(level_name):
	current_level ="res://"+level_name+".tscn"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
