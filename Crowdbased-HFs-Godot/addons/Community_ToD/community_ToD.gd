tool
extends EditorPlugin

const Community_ToD = preload("res://scenes/Center_ToD.tscn")

var community_ToD_instance


func _enter_tree():
	community_ToD_instance = Community_ToD.instance()
	
	get_editor_interface().get_editor_viewport().add_child(community_ToD_instance)
	
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
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
