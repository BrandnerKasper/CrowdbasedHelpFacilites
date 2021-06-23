tool
extends EditorPlugin


# Scenes and Icon constants
const Enhanced_Tool_Tip = preload("res://addons/enhanced_tool-tip/PopUp.tscn")
const Icon = preload("res://addons/enhanced_tool-tip/Enhanced_Tool-Tip_Icon.png")

var enhanced_tool_tip_instance


func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	add_custom_type("Enhanced_Tool-Tip", "Control", preload("Enhanced_Tool-Tip.gd"), Icon)


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Always remember to remove it from the engine when deactivated.
	remove_custom_type("Enhanced_Tool-Tip")
