extends SceneTree

# Exercise every live street handoff and capture each atmospheric transition screen.
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
	var required_methods := ["_start_game", "_begin_mcrae_transition", "_begin_newleaf_transition", "_begin_woodlawn_park_transition", "_begin_woodlawn_playground_transition"]
	for method in required_methods:
		if not game.has_method(method):
			push_error("The main scene is missing required transition method: %s" % method)
			quit(1)
			return

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

	var output_dir := ProjectSettings.globalize_path("res://build/atmosphere-captures")
	var mkdir_error := DirAccess.make_dir_recursive_absolute(output_dir)
	if mkdir_error != OK and not DirAccess.dir_exists_absolute(output_dir):
		push_error("Could not create atmosphere capture output directory: %s" % mkdir_error)
		quit(1)
		return

	var transitions := [
		{"method": "_begin_mcrae_transition", "street": "McRAE DRIVE", "capture": "cutscene_mcrae.png"},
		{"method": "_begin_newleaf_transition", "street": "NEWLEAF CRESCENT", "capture": "cutscene_newleaf.png"},
		{"method": "_begin_woodlawn_park_transition", "street": "WOODLAWN PARK", "capture": "cutscene_woodlawn_road.png"},
		{"method": "_begin_woodlawn_playground_transition", "street": "WOODLAWN PARK PLAYGROUND", "capture": "cutscene_woodlawn_park.png"}
	]
	for transition in transitions:
		game.call(str(transition["method"]))
		# The fade reaches the transition artwork at 0.38s; capture it while
		# the briefing is visible, before the next panorama is revealed.
		await create_timer(0.62).timeout
		await RenderingServer.frame_post_draw
		var transition_layer: CanvasLayer
		for child in game.get_children():
			if child is CanvasLayer and (child as CanvasLayer).layer == 100:
				transition_layer = child as CanvasLayer
				break
		if transition_layer == null:
			push_error("No active transition CanvasLayer while capturing %s." % transition["capture"])
			quit(1)
			return
		var background_has_material := false
		for child in transition_layer.get_children():
			if child is TextureRect and (child as TextureRect).material is ShaderMaterial:
				background_has_material = true
				break
		if not background_has_material:
			push_error("Transition background is missing its atmospheric shader: %s" % transition["capture"])
			quit(1)
			return
		var frame_image := root.get_texture().get_image()
		if frame_image == null or frame_image.is_empty():
			push_error("Rendered transition image was empty: %s" % transition["capture"])
			quit(1)
			return
		var output_path := output_dir.path_join(str(transition["capture"]))
		var save_error := frame_image.save_png(output_path)
		if save_error != OK or not FileAccess.file_exists(output_path) or FileAccess.get_file_as_bytes(output_path).is_empty():
			push_error("Could not save rendered transition capture: %s" % output_path)
			quit(1)
			return
		print("CUTSCENE_CAPTURE_SAVED=", output_path, " bytes=", FileAccess.get_file_as_bytes(output_path).size())

		var transition_finished := false
		for _attempt in range(100):
			await create_timer(0.1).timeout
			if str(game.get("current_street")) == str(transition["street"]) and not bool(game.get("street_transition_active")):
				transition_finished = true
				break
		if not transition_finished:
			push_error("Street transition did not finish: %s" % transition["street"])
			quit(1)
			return

		var atmosphere = game.get("horror_atmosphere")
		if not is_instance_valid(atmosphere):
			push_error("Destination street has no active environmental atmosphere: %s" % transition["street"])
			quit(1)
			return
		for bank_name in ["DriftingFogDepth_0", "DriftingFogDepth_2", "DriftingFogDepth_4"]:
			var bank := atmosphere.get_node_or_null(bank_name) as Sprite2D
			if bank == null or not is_equal_approx(bank.scale.x, maxf(float(game.get("world_end")), 960.0)):
				push_error("Atmospheric fog does not cover the full destination panorama (%s): %s" % [transition["street"], bank_name])
				quit(1)
				return
		print("ATMOSPHERE_FULL_WIDTH_VERIFIED=", transition["street"], " width=", game.get("world_end"))

	print("CUTSCENE_CAPTURE_COUNT=4")
	print("STREET_ATMOSPHERE_HANDOFF_COUNT=4")
	print("ATMOSPHERE_VISUAL_CAPTURE_COMPLETE")
	quit(0)
