extends SceneTree

# Render the real Leaside-to-McRae transition and capture the revealed McRae entrance.
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
	if not game.has_method("_start_game") or not game.has_method("_begin_mcrae_transition"):
		push_error("The main scene is missing the expected gameplay/transition methods.")
		quit(1)
		return

	# Start on the real Leaside panorama, then execute the same transition used in play.
	var leaside_panorama = game.call("_make_leaside_panorama")
	game.set("street_panorama", leaside_panorama)
	game.set("world_end", float(leaside_panorama.get_width()))
	game.set("current_street", "LEASIDE DRIVE")
	game.call("_start_game", 55.0, 475.0)
	for _frame in range(8):
		await process_frame
	if game.get("game_started") != true:
		push_error("The real Leaside gameplay session did not start.")
		quit(1)
		return

	game.call("_begin_mcrae_transition")
	var transition_finished := false
	for _attempt in range(140):
		await create_timer(0.1).timeout
		if game.get("current_street") == "McRAE DRIVE" and not bool(game.get("street_transition_active")):
			transition_finished = true
			break
	if not transition_finished:
		push_error("The real Leaside-to-McRae transition did not finish before capture.")
		quit(1)
		return

	await process_frame
	await RenderingServer.frame_post_draw
	var output_dir := ProjectSettings.globalize_path("res://build/atmosphere-captures")
	if not DirAccess.dir_exists_absolute(output_dir):
		var mkdir_error := DirAccess.make_dir_recursive_absolute(output_dir)
		if mkdir_error != OK:
			push_error("Could not create atmosphere capture output directory: %s" % mkdir_error)
			quit(1)
			return

	var capture_delays := [0.0, 2.0, 4.0]
	for i in range(capture_delays.size()):
		if capture_delays[i] > 0.0:
			await create_timer(float(capture_delays[i])).timeout
			await RenderingServer.frame_post_draw
		var frame_image := root.get_texture().get_image()
		if frame_image == null or frame_image.is_empty():
			push_error("Rendered McRae viewport image was empty at capture %d." % i)
			quit(1)
			return
		var output_path := output_dir.path_join("mcrae_entrance_%02d.png" % i)
		var save_error := frame_image.save_png(output_path)
		if save_error != OK or not FileAccess.file_exists(output_path):
			push_error("Could not save McRae capture %d (error %s)." % [i, save_error])
			quit(1)
			return
		var file_bytes := FileAccess.get_file_as_bytes(output_path)
		if file_bytes.is_empty():
			push_error("McRae capture %d was created empty." % i)
			quit(1)
			return
		print("MCRAE_CAPTURE_SAVED=", output_path, " bytes=", file_bytes.size(), " size=", frame_image.get_size())

	print("MCRAE_CAPTURE_COUNT=3")
	print("ATMOSPHERE_VISUAL_CAPTURE_COMPLETE")
	quit(0)
