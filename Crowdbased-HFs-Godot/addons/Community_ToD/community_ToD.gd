tool
extends EditorPlugin

# Handles the initialization and deletion of the Community ToD plugin

const Community_ToD = preload("res://addons/Community_ToD/ToD.tscn")
const Icon = preload("res://addons/Community_ToD/cloud.svg")

var _community_ToD_instance
var _community_ToD_Viewport


func _enter_tree():
	_community_ToD_instance = Community_ToD.instance()
	
	_community_ToD_Viewport = get_editor_interface().get_editor_viewport().add_child(_community_ToD_instance)
	make_visible(false)


func _exit_tree():
	if _community_ToD_instance:
		_community_ToD_instance.queue_free()


func has_main_screen():
	return true


func make_visible(visible):
	if _community_ToD_instance:
		_community_ToD_instance.visible = visible


func get_plugin_name():
	return "Community ToD"


func get_plugin_icon():
	return Icon
	#return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
