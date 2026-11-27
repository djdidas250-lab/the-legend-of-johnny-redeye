extends Node2D
class_name EnvironmentalAtmosphere

# All atmosphere lives between the panorama and the actors. The parent game
# canvas alone receives the 2D lights; player/enemy/boss canvases keep mask 1.
const BACKGROUND_LIGHT_MASK := 2
const BACKGROUND_NIGHT_GRADE_SHADER := """
shader_type canvas_item;

float luma(vec3 color) {
    return dot(color, vec3(0.2126, 0.7152, 0.0722));
}

void fragment() {
    vec4 texel = texture(TEXTURE, UV);
    vec3 source = texel.rgb;
    float brightness = luma(source);

    // Separate the open sky, vegetation, built surfaces and road before
    // grading. This retains source-art detail instead of applying one tint.
    float sky_region = 1.0 - smoothstep(0.30, 0.56, UV.y);
    float green_signal = clamp((source.g - max(source.r, source.b)) * 3.4, 0.0, 1.0);
    float foliage_region = green_signal * smoothstep(0.12, 0.31, UV.y);
    float blue_sky = clamp((source.b - source.r) * 2.8, 0.0, 1.0);

    vec3 night_sky = mix(
        vec3(0.006, 0.009, 0.024),
        source * vec3(0.14, 0.20, 0.37),
        smoothstep(0.14, 0.72, brightness)
    );
    night_sky = mix(night_sky, vec3(0.032, 0.044, 0.078), blue_sky * 0.24);

    vec3 cool_surface = source * vec3(0.24, 0.31, 0.44);
    cool_surface = mix(
        cool_surface,
        source * vec3(0.37, 0.44, 0.57),
        smoothstep(0.36, 0.86, brightness) * 0.30
    );
    vec3 night_foliage = source * vec3(0.16, 0.28, 0.30);
    vec3 night_ground = mix(cool_surface, night_foliage, foliage_region * 0.66);

    // A narrow horizon haze gives distant houses and tree lines separation.
    float horizon_haze = exp(-pow((UV.y - 0.535) * 13.0, 2.0)) * 0.17;
    night_ground = mix(night_ground, vec3(0.060, 0.074, 0.112), horizon_haze);

    vec3 graded = mix(night_ground, night_sky, sky_region);

    // Retain small warm details in windows, signs and existing practical lights.
    float warm_detail = smoothstep(0.10, 0.30, source.r - source.b)
        * smoothstep(0.28, 0.68, brightness);
    graded = mix(graded, source * vec3(0.78, 0.54, 0.34), warm_detail * 0.34);

    // Keep the brightest painted details legible without lifting the whole image.
    float highlight_detail = smoothstep(0.78, 0.98, brightness) * (1.0 - sky_region * 0.35);
    graded = mix(graded, source * vec3(0.68, 0.73, 0.84), highlight_detail * 0.20);

    COLOR = vec4(max(graded, vec3(0.0)), texel.a);
}
"""

const FOG_SHADER := """
shader_type canvas_item;
render_mode unshaded, blend_mix;

uniform float drift_speed = 0.010;
uniform float opacity = 0.30;
uniform float scale_x = 1.0;
uniform float scale_y = 1.0;
uniform float vertical_offset = 0.0;
uniform vec3 fog_tint : source_color = vec3(0.48, 0.54, 0.64);

void fragment() {
    vec2 uv = UV;
    float t = TIME * drift_speed;
    float x = uv.x * scale_x;

    // Broad, smoothly blended cloud masses. No cellular/value noise or hard
    // thresholds: layered low-frequency waves create continuous mist banks.
    float wave_a = sin(x * 3.2 + t * 1.00 + sin(uv.y * 2.4 - t * 0.19) * 0.82);
    float wave_b = sin(x * 5.0 - t * 0.62 + sin(uv.y * 1.7 + t * 0.14) * 0.68);
    float wave_c = cos(x * 1.75 + t * 0.38 + sin(uv.y * 3.1 - t * 0.11) * 0.52);
    float cloud_form = wave_a * 0.46 + wave_b * 0.25 + wave_c * 0.29;
    float cloud_density = 0.56 + cloud_form * 0.38;

    // The mist body hugs the road, with a gently undulating upper boundary.
    float center = 0.585 + vertical_offset
        + sin(uv.x * 2.2 + t * 0.31) * 0.045
        + sin(uv.x * 4.1 - t * 0.21) * 0.020;
    float ground_edge = smoothstep(0.385 + vertical_offset, 0.505 + vertical_offset, uv.y);
    float top_edge = 1.0 - smoothstep(center + 0.035, center + 0.255, uv.y);
    float body = ground_edge * top_edge;

    // Preserve a soft continuous base while allowing broad banks to gather
    // and thin naturally. Density never forms isolated pixel-like patches.
    float density = mix(0.34, 1.0, smoothstep(0.20, 0.86, cloud_density));
    float alpha = body * density * opacity * 1.18;
    COLOR = vec4(fog_tint, clamp(alpha, 0.0, 0.34));
}
"""

static func create_background_grade_material() -> ShaderMaterial:
    var shader := Shader.new()
    shader.code = BACKGROUND_NIGHT_GRADE_SHADER
    var grade := ShaderMaterial.new()
    grade.shader = shader
    return grade


static func create_cutscene_atmosphere_material(sword_glow: bool = false) -> ShaderMaterial:
    # Apply the same cool night grade and low drifting mist to transition artwork.
    # The material is attached only to the full-screen background TextureRect;
    # briefing panels and all gameplay actors remain unaffected.
    var shader := Shader.new()
    shader.code = """
shader_type canvas_item;
render_mode unshaded;
uniform bool sword_glow_enabled = false;
float luma(vec3 c) {
    return dot(c, vec3(0.2126, 0.7152, 0.0722));
}
void fragment() {
    vec4 texel = texture(TEXTURE, UV);
    vec3 source = texel.rgb;
    float brightness = luma(source);
    float sky = 1.0 - smoothstep(0.30, 0.56, UV.y);
    float green_signal = clamp((source.g - max(source.r, source.b)) * 3.4, 0.0, 1.0);
    float foliage = green_signal * smoothstep(0.12, 0.31, UV.y);
    vec3 night_sky = mix(vec3(0.006, 0.009, 0.024), source * vec3(0.14, 0.20, 0.37), smoothstep(0.14, 0.72, brightness));
    vec3 cool_surface = source * vec3(0.24, 0.31, 0.44);
    vec3 night_ground = mix(cool_surface, source * vec3(0.16, 0.28, 0.30), foliage * 0.66);
    float horizon = exp(-pow((UV.y - 0.535) * 13.0, 2.0)) * 0.17;
    night_ground = mix(night_ground, vec3(0.060, 0.074, 0.112), horizon);
    vec3 graded = mix(night_ground, night_sky, sky);
    float warm = smoothstep(0.10, 0.30, source.r - source.b) * smoothstep(0.28, 0.68, brightness);
    graded = mix(graded, source * vec3(0.78, 0.54, 0.34), warm * 0.34);
    float t = TIME * 0.010;
    float wave_a = sin(UV.x * 9.0 + t + sin(UV.y * 2.4 - t * 0.19) * 0.82);
    float wave_b = sin(UV.x * 14.0 - t * 0.62 + sin(UV.y * 1.7 + t * 0.14) * 0.68);
    float cloud = 0.56 + (wave_a * 0.62 + wave_b * 0.38) * 0.22;
    float center = 0.70 + sin(UV.x * 2.2 + t * 0.31) * 0.035;
    float ground_edge = smoothstep(0.47, 0.59, UV.y);
    float top_edge = 1.0 - smoothstep(center, center + 0.25, UV.y);
    float fog_alpha = ground_edge * top_edge * mix(0.035, 0.12, smoothstep(0.2, 0.86, cloud));
    if (sword_glow_enabled) {
        // Keep the burning carnival's original reds and firelight prominent;
        // the transition grade remains unchanged for every other cutscene.
        graded = mix(graded, source, 0.62);
        fog_alpha *= 0.55;
    }
    graded = mix(graded, vec3(0.39, 0.45, 0.56), fog_alpha);

    // The sword's fiery blade runs diagonally from the protagonist's hands
    // toward the upper-right corner of the supplied 1584x672 artwork.
    // Add only a soft, pulsing amber halo around that existing blade; the
    // source pixels remain intact and the effect is disabled on other scenes.
    if (sword_glow_enabled) {
        float source_aspect = 2.3571429;
        vec2 sword_point = vec2(UV.x * source_aspect, UV.y);
        vec2 blade_start = vec2(0.570 * source_aspect, 0.535);
        vec2 blade_end = vec2(0.738 * source_aspect, 0.025);
        vec2 blade_axis = blade_end - blade_start;
        float blade_t = clamp(dot(sword_point - blade_start, blade_axis) / dot(blade_axis, blade_axis), 0.0, 1.0);
        float blade_distance = length(sword_point - (blade_start + blade_axis * blade_t));
        float halo = 1.0 - smoothstep(0.010, 0.105, blade_distance);
        float flame_detail = smoothstep(0.10, 0.30, source.r - source.b) * smoothstep(0.20, 0.62, brightness);
        float pulse = 0.80 + 0.20 * sin(TIME * 2.4);
        graded += vec3(1.0, 0.40, 0.075) * halo * pulse * 0.34;
        graded = mix(graded, max(graded, source * vec3(1.22, 1.08, 0.88)), halo * flame_detail * 0.22);
    }
    COLOR = vec4(graded, texel.a);
}
"""
    var material := ShaderMaterial.new()
    material.shader = shader
    material.set_shader_parameter("sword_glow_enabled", sword_glow)
    return material


static func create_woodlawn_victory_material() -> ShaderMaterial:
    # Reuse the game's established cool nighttime grade for this victory artwork.
    # Fog and embers are independent scene layers, so the source image stays clean.
    return create_background_grade_material()


static func create_woodlawn_victory_fog_material() -> ShaderMaterial:
    var shader := Shader.new()
    shader.code = FOG_SHADER
    var material := ShaderMaterial.new()
    material.shader = shader
    material.set_shader_parameter("drift_speed", 0.010)
    material.set_shader_parameter("opacity", 0.25)
    material.set_shader_parameter("scale_x", 0.92)
    material.set_shader_parameter("scale_y", 1.0)
    material.set_shader_parameter("vertical_offset", 0.025)
    material.set_shader_parameter("fog_tint", Color("#77869f"))
    return material


var _world_width := 960.0
var _street_name := ""
var _park_mode := false
var _leaves: CPUParticles2D
var _lights: Array[PointLight2D] = []
var _occluders: Array[LightOccluder2D] = []
var _occluder_origins: Array[Vector2] = []
var _elapsed := 0.0

func configure(world_width: float, street_name: String = "") -> void:
    _world_width = maxf(world_width, 960.0)
    _street_name = street_name.to_upper()
    _park_mode = _street_name.contains("WOODLAWN")
    z_index = 300
    _build_fog_banks()
    _build_tree_occluders()
    _build_ambient_lights()
    _build_falling_leaves()

func _white_pixel() -> Texture2D:
    var image := Image.create(1, 1, false, Image.FORMAT_RGBA8)
    image.fill(Color.WHITE)
    return ImageTexture.create_from_image(image)

func _build_fog_banks() -> void:
    var pixel := _white_pixel()
    var density := 1.0
    var fog_palette := [Color("#778398"), Color("#667287"), Color("#929baa")]
    if _park_mode:
        density = 1.16
        fog_palette = [Color("#71839d"), Color("#596a83"), Color("#8998ad")]
    elif _street_name.contains("LEASIDE"):
        density = 1.08
        fog_palette = [Color("#778398"), Color("#665d70"), Color("#a19a9d")]
    elif _street_name.contains("MCRAE"):
        density = 0.96
        fog_palette = [Color("#7b899c"), Color("#657286"), Color("#9aa4ad")]
    var settings := [
        {"speed": 0.010, "opacity": 0.27 * density, "sx": 0.85, "sy": 1.0, "offset": 0.00, "tint": fog_palette[0], "z": 0},
        {"speed": -0.008, "opacity": 0.19 * density, "sx": 1.10, "sy": 1.0, "offset": -0.055, "tint": fog_palette[1], "z": 2},
        {"speed": 0.014, "opacity": 0.13 * density, "sx": 1.35, "sy": 1.0, "offset": 0.045, "tint": fog_palette[2], "z": 4}
    ]
    for setting in settings:
        var bank := Sprite2D.new()
        bank.name = "DriftingFogDepth_%d" % int(setting["z"])
        bank.texture = pixel
        bank.centered = false
        bank.position = Vector2.ZERO
        bank.scale = Vector2(_world_width, 540.0)
        bank.z_index = int(setting["z"])
        bank.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
        var material := ShaderMaterial.new()
        material.shader = _make_fog_shader()
        material.set_shader_parameter("drift_speed", float(setting["speed"]))
        material.set_shader_parameter("opacity", float(setting["opacity"]))
        material.set_shader_parameter("scale_x", float(setting["sx"]))
        material.set_shader_parameter("scale_y", float(setting["sy"]))
        material.set_shader_parameter("vertical_offset", float(setting["offset"]))
        material.set_shader_parameter("fog_tint", setting["tint"])
        bank.material = material
        add_child(bank)

func _make_fog_shader() -> Shader:
    var shader := Shader.new()
    shader.code = FOG_SHADER
    return shader

func _build_tree_occluders() -> void:
    # Invisible occluder silhouettes are aligned to the supplied panorama's
    # tree groups. Their soft shadows fall onto the scenery only.
    var anchors := [0.08, 0.20, 0.32, 0.49, 0.64, 0.81, 0.92] if _street_name.contains("NEWLEAF") else (
        [0.12, 0.28, 0.43, 0.59, 0.75, 0.90] if _park_mode else (
        [0.07, 0.38, 0.58, 0.78, 0.93] if _street_name.contains("MCRAE") else [0.18, 0.34, 0.51, 0.68, 0.86]))
    var tree_shape := OccluderPolygon2D.new()
    tree_shape.closed = true
    tree_shape.cull_mode = OccluderPolygon2D.CULL_DISABLED
    tree_shape.polygon = PackedVector2Array([
        Vector2(-14.0, 132.0), Vector2(-22.0, 38.0),
        Vector2(-82.0, 20.0), Vector2(-103.0, -17.0),
        Vector2(-91.0, -61.0), Vector2(-57.0, -100.0),
        Vector2(-22.0, -124.0), Vector2(18.0, -121.0),
        Vector2(60.0, -93.0), Vector2(96.0, -49.0),
        Vector2(88.0, -8.0), Vector2(47.0, 21.0),
        Vector2(22.0, 38.0), Vector2(14.0, 132.0)
    ])
    for i in range(anchors.size()):
        var occluder := LightOccluder2D.new()
        occluder.name = "TreeCanopyOccluder_%02d" % i
        occluder.occluder = tree_shape
        occluder.occluder_light_mask = 2
        # Draw the occluder before the panorama so it can cast onto it.
        occluder.z_as_relative = false
        occluder.z_index = -1
        occluder.position = Vector2(_world_width * float(anchors[i]), 175.0 + float(i % 2) * 22.0)
        add_child(occluder)
        _occluders.append(occluder)
        _occluder_origins.append(occluder.position)

func _build_ambient_lights() -> void:
    var light_texture := _make_organic_light_texture()
    var positions := [0.18, 0.48, 0.82] if _park_mode else (
        [0.36, 0.61, 0.76] if _street_name.contains("NEWLEAF") else (
        [0.43, 0.76] if _street_name.contains("MCRAE") else (
        [0.39, 0.67] if _street_name.contains("LEASIDE") else [0.20, 0.51, 0.82])))
    for i in range(positions.size()):
        var light := PointLight2D.new()
        light.name = "EnvironmentalBounceLight_%02d" % i
        light.texture = light_texture
        light.texture_scale = 2.2
        light.offset = Vector2(0.0, 58.0)
        if _park_mode:
            light.color = Color("#8fa7c8") if i % 2 == 0 else Color("#a8b3c4")
            light.energy = 0.18 if i % 2 == 0 else 0.14
        elif _street_name.contains("LEASIDE"):
            light.color = Color("#a6a6bd") if i != 1 else Color("#c1a58d")
            light.energy = 0.18 if i != 1 else 0.15
        else:
            light.color = Color("#9aacc5") if i != 1 else Color("#c1a58d")
            light.energy = 0.20 if i != 1 else 0.16
        light.range_item_cull_mask = 2
        light.shadow_item_cull_mask = 2
        light.shadow_enabled = i < 2
        light.shadow_filter = Light2D.SHADOW_FILTER_PCF5
        light.shadow_filter_smooth = 1.25
        light.shadow_color = Color(0.012, 0.018, 0.032, 0.42)
        light.set_meta("base_energy", light.energy)
        light.position = Vector2(_world_width * float(positions[i]), 135.0 if _park_mode else 150.0)
        add_child(light)
        _lights.append(light)

func _make_organic_light_texture() -> Texture2D:
    var image := Image.create(128, 256, false, Image.FORMAT_RGBA8)
    var center := Vector2(63.5, 127.5)
    for y in range(256):
        for x in range(128):
            var delta := Vector2((float(x) - center.x) / 63.5, (float(y) - center.y) / 127.5)
            var radius := delta.length()
            var angle := atan2(delta.y, delta.x)
            var irregularity := 0.035 * sin(angle * 5.0 + 0.8) + 0.022 * sin(angle * 9.0 - 1.1)
            var adjusted_radius := maxf(0.0, radius + irregularity)
            var falloff := 1.0 - smoothstep(0.10, 1.0, adjusted_radius)
            var alpha := pow(maxf(falloff, 0.0), 2.15)
            image.set_pixel(x, y, Color(1.0, 1.0, 1.0, alpha))
    return ImageTexture.create_from_image(image)

func _make_leaf_texture() -> Texture2D:
    var image := Image.create(24, 12, false, Image.FORMAT_RGBA8)
    for y in range(12):
        for x in range(24):
            var px := absf((float(x) - 11.5) / 11.5)
            var py := absf((float(y) - 5.5) / 5.5)
            var half_width := 0.04 + 0.82 * (1.0 - px) * (0.45 + 0.55 * px)
            var edge := half_width - py
            var alpha := smoothstep(-0.12, 0.12, edge)
            image.set_pixel(x, y, Color(1.0, 1.0, 1.0, alpha))
    return ImageTexture.create_from_image(image)

func _build_falling_leaves() -> void:
    if not _park_mode:
        return
    _leaves = CPUParticles2D.new()
    _leaves.name = "WindblownParkLeaves"
    _leaves.amount = 16
    _leaves.lifetime = 7.5
    _leaves.preprocess = 2.0
    _leaves.emitting = true
    _leaves.local_coords = false
    _leaves.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
    _leaves.emission_rect_extents = Vector2(580.0, 150.0)
    _leaves.direction = Vector2(-1.0, 0.20)
    _leaves.spread = 28.0
    _leaves.gravity = Vector2(-0.3, 8.0)
    _leaves.initial_velocity_min = 5.0
    _leaves.initial_velocity_max = 16.0
    _leaves.angular_velocity_min = -42.0
    _leaves.angular_velocity_max = 42.0
    _leaves.scale_amount_min = 0.55
    _leaves.scale_amount_max = 1.1
    _leaves.color = Color(0.72, 0.51, 0.30, 0.40)
    _leaves.texture = _make_leaf_texture()
    _leaves.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
    _leaves.z_index = 49
    add_child(_leaves)

func follow_camera(camera_position: Vector2) -> void:
    if is_instance_valid(_leaves):
        _leaves.global_position = camera_position

func _process(delta: float) -> void:
    _elapsed += delta
    for i in range(_lights.size()):
        var light := _lights[i]
        if not is_instance_valid(light):
            continue
        var slow_breath := sin(_elapsed * (0.31 + float(i) * 0.07) + float(i) * 1.9)
        var gentle_flicker := sin(_elapsed * (2.7 + float(i) * 0.8) + float(i) * 2.4)
        var base_energy := float(light.get_meta("base_energy", 0.20))
        light.energy = base_energy + slow_breath * 0.012 + gentle_flicker * 0.006
    for i in range(_occluders.size()):
        var occluder := _occluders[i]
        if not is_instance_valid(occluder):
            continue
        var wind_phase := _elapsed * 0.34 + float(i) * 1.61
        occluder.position = _occluder_origins[i] + Vector2(sin(wind_phase) * 2.2, cos(wind_phase * 0.73) * 0.8)
