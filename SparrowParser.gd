tool
extends XMLParser
class_name SparrowParser


func open(file: String) -> int:
	var err: int = .open(file)
	if err != OK:
		return err

	if _check_if_sparrow() == false:
		return ERR_FILE_UNRECOGNIZED

	return OK


func get_as_sparrow_frames(texture: Texture, default_fps: int = 10, custom_anim_fps: Dictionary = {}, custom_anim_loop: Dictionary = {}) -> SpriteFrames:
	var sprite_frames: SpriteFrames = SpriteFrames.new()
	sprite_frames.remove_animation("default")

	seek(0)

	while read() != ERR_FILE_EOF:
		if get_node_name() == "SubTexture":
			var frame_name: String = get_named_attribute_value_safe("name")
			var anim_name: String = frame_name.left(frame_name.length() - 4)

			var rect: Rect2 = Rect2()
			var offset: Vector2 = Vector2()

			rect.position.x = float(get_named_attribute_value_safe("x"))
			rect.position.y = float(get_named_attribute_value_safe("y"))
			rect.size.x = float(get_named_attribute_value_safe("width"))
			rect.size.y = float(get_named_attribute_value_safe("height"))

			offset.x = -float(get_named_attribute_value_safe("pivotX"))
			offset.y = -float(get_named_attribute_value_safe("pivotY"))

			if not sprite_frames.has_animation(anim_name):
				sprite_frames.add_animation(anim_name)
				sprite_frames.set_animation_speed(anim_name, default_fps)

				for a in custom_anim_fps.keys():
					var a_str: String = str(a)
					if a in anim_name:
						sprite_frames.set_animation_speed(anim_name, (custom_anim_fps[a] as int))
						break

				for a in custom_anim_loop.keys():
					var a_str: String = str(a)
					if a in anim_name:
						sprite_frames.set_animation_loop(anim_name, (custom_anim_loop[a] as bool))
						break

			var atlas_texture: AtlasTexture = AtlasTexture.new()
			atlas_texture.atlas = texture
			atlas_texture.region = rect
			sprite_frames.add_frame(anim_name, atlas_texture)

	return sprite_frames


func _check_if_sparrow() -> bool:
	seek(0)

	while read() != ERR_FILE_EOF:
		if get_node_name() == "TextureAtlas":
			return true

	printerr("Not a valid Sparrow Atlas.")
	return false


func get_class() -> String : return "SparrowParser"
