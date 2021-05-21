tool
extends EditorPlugin

const Community_ToD = preload("res://scenes/ToD.tscn")
const icon = preload("res://icon/cloud.svg")

var community_ToD_instance

var Community_ToD_Viewport


func _enter_tree():
	community_ToD_instance = Community_ToD.instance()
	
	Community_ToD_Viewport = get_editor_interface().get_editor_viewport().add_child(community_ToD_instance)
	make_visible(false)


func _exit_tree():
	if community_ToD_instance:
		community_ToD_instance.queue_free()


func has_main_screen():
	return true


func make_visible(visible):
	if community_ToD_instance:
		community_ToD_instance.visible = visible


func get_plugin_name():
	return "Community ToD"


func get_plugin_icon():
	return icon
	#return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
