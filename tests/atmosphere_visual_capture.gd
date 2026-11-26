extends SceneTree

# Runs the real main scene in a virtual display, starts a real street gameplay
# session, and captures the live atmosphere shader at several animation times.
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
	# Start on the real Newleaf street, where the fog system is active.
	game.call("_start_game", 320.0, 475.0)
	for _frame in range(4):
		await process_frame
	await RenderingServer.frame_post_draw

	var output_dir := ProjectSettings.globalize_path("res://build/atmosphere_visuals")
	DirAccess.make_dir_recursive_absolute(output_dir)
	var capture_times := [0.35, 1.8, 3.6, 5.4]
	for i in range(capture_times.size()):
		await create_timer(float(capture_times[i])).timeout
		await RenderingServer.frame_post_draw
		var frame_image := root.get_texture().get_image()
		if frame_image == null or frame_image.is_empty():
			push_error("Rendered viewport image was empty at capture %d." % i)
			quit(1)
			return
		var output_path := output_dir.path_join("newleaf_fog_%02d.png" % i)
		var save_error := frame_image.save_png(output_path)
		if save_error != OK:
			push_error("Could not save rendered atmosphere frame: " + output_path)
			quit(1)
			return
		print("ATMOSPHERE_VISUAL_CAPTURE=", output_path, " size=", frame_image.get_size())
	print("ATMOSPHERE_VISUAL_CAPTURE_COMPLETE")
	quit(0)
