extends SceneTree

# Runs the real main scene in a virtual display, starts a real Newleaf street
# session, and writes lossless rendered frames for assistant-side visual review.
func _initialize() -> void:
	call_deferred("_run_visual_capture")

func _run_visual_capture() -> void:
	Engine.max_fps = 60
	var scene := load("res://scenes/main.tscn") as PackedScene
	if scene == null:
		push_error("Could not load the actual game main scene.")
		quit(1)
		return

	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	if not game.has_method("_start_game"):
		push_error("The main scene does not expose the expected gameplay start method.")
		quit(1)
		return

	# Start the actual Newleaf gameplay session, not a synthetic fog preview.
	game.call("_start_game", 320.0, 475.0)
	for _frame in range(8):
		await process_frame
	if game.get("game_started") != true:
		push_error("The real gameplay session did not start before visual capture.")
		quit(1)
		return
	await RenderingServer.frame_post_draw

	var output_dir := ProjectSettings.globalize_path("res://build/atmosphere-captures")
	if not DirAccess.dir_exists_absolute(output_dir):
		var mkdir_error := DirAccess.make_dir_recursive_absolute(output_dir)
		if mkdir_error != OK:
			push_error("Could not create atmosphere capture output directory: %s" % mkdir_error)
			quit(1)
			return

	var capture_times := [0.8, 3.8, 7.0]
	for i in range(capture_times.size()):
		await create_timer(float(capture_times[i])).timeout
		await RenderingServer.frame_post_draw
		var frame_image := root.get_texture().get_image()
		if frame_image == null or frame_image.is_empty():
			push_error("Rendered viewport image was empty at capture %d." % i)
			quit(1)
			return

		var output_path := output_dir.path_join("newleaf_%02d.png" % i)
		var save_error := frame_image.save_png(output_path)
		if save_error != OK or not FileAccess.file_exists(output_path):
			push_error("Could not save atmosphere capture %d (error %s)." % [i, save_error])
			quit(1)
			return
		var file_bytes := FileAccess.get_file_as_bytes(output_path)
		if file_bytes.is_empty():
			push_error("Atmosphere capture %d was created empty." % i)
			quit(1)
			return
		print("ATMOSPHERE_CAPTURE_SAVED=", output_path, " bytes=", file_bytes.size(), " size=", frame_image.get_size())

	print("ATMOSPHERE_CAPTURE_COUNT=3")
	print("ATMOSPHERE_VISUAL_CAPTURE_COMPLETE")
	quit(0)
