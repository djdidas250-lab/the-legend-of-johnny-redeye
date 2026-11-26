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

	var capture_times := [0.8, 3.8]
	for i in range(capture_times.size()):
		await create_timer(float(capture_times[i])).timeout
		await RenderingServer.frame_post_draw
		var frame_image := root.get_texture().get_image()
		if frame_image == null or frame_image.is_empty():
			push_error("Rendered viewport image was empty at capture %d." % i)
			quit(1)
			return
		frame_image.resize(640, 360, Image.INTERPOLATE_LANCZOS)
		var jpg_bytes := frame_image.save_jpg_to_buffer(0.48)
		var encoded := Marshalls.raw_to_base64(jpg_bytes)
		print("ATMOSPHERE_FRAME_BEGIN_%02d" % i)
		print(encoded)
		print("ATMOSPHERE_FRAME_END_%02d" % i)
		print("ATMOSPHERE_VISUAL_CAPTURE size=", frame_image.get_size(), " jpeg_bytes=", jpg_bytes.size())
	print("ATMOSPHERE_VISUAL_CAPTURE_COMPLETE")
	quit(0)
