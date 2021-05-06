extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _make_custom_tooltip(for_text):
	var tooltip = preload("res://scenes/PopUp.tscn").instance()
	tooltip._set_Title(get_parent().get_name())
	tooltip._set_Body_Text(for_text)
	return tooltip
