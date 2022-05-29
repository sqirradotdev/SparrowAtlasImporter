tool
extends EditorImportPlugin
class_name SparrowImporter


func get_importer_name() -> String:
	return "sparrow.atlas.importer"


func get_visible_name() -> String:
	return "SpriteFrames"


func get_recognized_extensions() -> Array:
	return ["xml"]


func get_save_extension() -> String:
	return "tres"


func get_resource_type() -> String:
	return "SpriteFrames"


func get_preset_count() -> int:
	return 1


func get_preset_name(preset: int) -> String:
	return "Default"


func get_import_options(preset: int) -> Array:
	return [
		{
			"name": "group_frames",
			"default_value": true
		},
		{
			"name": "image_file_format",
			"default_value": "png"
		},
		{
			"name": "default_fps",
			"default_value": 10
		},
		{
			"name": "custom_anim_fps",
			"default_value": {}
		},
		{
			"name": "custom_anim_loop",
			"default_value": {}
		}
	]


func get_option_visibility(option: String, options: Dictionary) -> bool:
	return true


func import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array, gen_files: Array) -> int:
	save_path += "." + get_save_extension()
	var image_path: String = source_file.substr(0, source_file.rfind(".") + 1) + options["image_file_format"]
	#print("Source file: " + source_file + ", Save path: " + save_path)
	#print("Image path: " + image_path)

	var sparrow_parser: SparrowParser = SparrowParser.new()
	var err: int = sparrow_parser.open(source_file)
	if err != OK:
		return err

	var sprite_frames: SpriteFrames = sparrow_parser.get_as_sparrow_frames(ResourceLoader.load(image_path), options["default_fps"], options["custom_anim_fps"], options["custom_anim_loop"])
	#print(sprite_frames)

	if not ResourceLoader.exists(image_path):
		return ERR_FILE_NOT_FOUND

	#print(sprite_frames.texture)

	return ResourceSaver.save(save_path, sprite_frames)


func get_class() -> String: return "SparrowImporter"
