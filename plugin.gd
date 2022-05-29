tool
extends EditorPlugin


func _enter_tree() -> void:
	#add_custom_type("SparrowFrames", "Resource", preload("res://addons/sparrow_atlas_importer/SparrowFrames.gd"), null)
	add_import_plugin(SparrowImporter.new())


func _exit_tree() -> void:
	pass
