extends Node2D
class_name EnvironmentalAtmosphere

# All atmosphere lives between the panorama and the actors. The parent game
# canvas alone receives the 2D lights; player/enemy/boss canvases keep mask 1.
const BACKGROUND_LIGHT_MASK := 2
const FOG_SHADER := """
shader_type canvas_item;
render_mode unshaded;

uniform float drift_speed = 0.012;
uniform float opacity = 0.12;
uniform float scale_x = 8.0;
uniform float scale_y = 3.0;
uniform float vertical_offset = 0.0;
uniform vec3 fog_tint : source_color = vec3(0.55, 0.61, 0.69);

float hash21(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise2(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash21(i);
    float b = hash21(i + vec2(1.0, 0.0));
    float c = hash21(i + vec2(0.0, 1.0));
    float d = hash21(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += noise2(p) * amplitude;
        p = p * 2.03 + vec2(13.7, 7.1);
        amplitude *= 0.5;
    }
    return value;
}

void fragment() {
    vec2 uv = UV;
    float t = TIME * drift_speed;
    vec2 field = uv * vec2(scale_x, scale_y);
    float broad = fbm(field + vec2(t, sin(uv.x * 8.0 + t) * 0.10));
    float fine = fbm(field * 2.15 + vec2(-t * 1.42, t * 0.24));
    float rolling_density = smoothstep(0.47, 0.76, broad * 0.66 + fine * 0.34);
    float lower_bank = smoothstep(0.58 + vertical_offset, 0.78 + vertical_offset, uv.y);
    lower_bank *= 1.0 - smoothstep(0.91, 0.995, uv.y);
    float wispy_breakup = smoothstep(0.30, 0.80, fine);
    float alpha = rolling_density * lower_bank * wispy_breakup * opacity;
    float low_curl = smoothstep(0.73, 0.96, uv.y) * smoothstep(0.42, 0.72, broad);
    alpha += low_curl * opacity * 0.22;
    COLOR = vec4(fog_tint, clamp(alpha, 0.0, 0.20));
}
"""

const SHADOW_SHADER := """
shader_type canvas_item;
render_mode unshaded;

uniform float seed = 0.0;
uniform float sway = 0.02;

float segment_distance(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / max(dot(ba, ba), 0.0001), 0.0, 1.0);
    return length(pa - ba * h);
}

void fragment() {
    vec2 p = UV;
    float wind = sin(TIME * 0.43 + seed) * sway;
    p.x += wind * (1.0 - p.y);
    p.y += cos(TIME * 0.31 + seed) * 0.008 * (p.x - 0.5);

    float d = 1.0;
    // A branching canopy silhouette, projected across the pavement rather
    // than a screen-wide darkening layer.
    d = min(d, segment_distance(p, vec2(0.50, 1.08), vec2(0.50, 0.43)));
    d = min(d, segment_distance(p, vec2(0.50, 0.69), vec2(0.17, 0.29)));
    d = min(d, segment_distance(p, vec2(0.50, 0.61), vec2(0.86, 0.22)));
    d = min(d, segment_distance(p, vec2(0.30, 0.45), vec2(0.12, 0.18)));
    d = min(d, segment_distance(p, vec2(0.69, 0.42), vec2(0.91, 0.10)));
    d = min(d, segment_distance(p, vec2(0.50, 0.83), vec2(0.34, 0.57)));
    d = min(d, segment_distance(p, vec2(0.50, 0.78), vec2(0.67, 0.51)));
    float branches = 1.0 - smoothstep(0.008, 0.026, d);
    float edge_fade = 1.0 - smoothstep(0.56, 0.78, distance(UV, vec2(0.5, 0.5)));
    float softness = 0.78 + 0.22 * sin((UV.x * 19.0 + UV.y * 13.0) + TIME * 0.18 + seed);
    float alpha = branches * edge_fade * softness * 0.14;
    COLOR = vec4(vec3(0.012, 0.016, 0.026), alpha);
}
"""

var _world_width := 960.0
var _dust: CPUParticles2D
var _lights: Array[PointLight2D] = []
var _elapsed := 0.0

func configure(world_width: float) -> void:
    _world_width = maxf(world_width, 960.0)
    z_index = 300
    _build_fog_banks()
    _build_canopy_shadows()
    _build_ambient_lights()
    _build_dust_field()

func _white_pixel() -> Texture2D:
    var image := Image.create(1, 1, false, Image.FORMAT_RGBA8)
    image.fill(Color.WHITE)
    return ImageTexture.create_from_image(image)

func _build_fog_banks() -> void:
    var pixel := _white_pixel()
    var settings := [
        {"speed": 0.010, "opacity": 0.105, "sx": 7.0, "sy": 3.0, "offset": 0.00, "tint": Color("#8a96a8"), "z": 0},
        {"speed": -0.016, "opacity": 0.078, "sx": 12.0, "sy": 4.1, "offset": -0.045, "tint": Color("#697486"), "z": 2},
        {"speed": 0.023, "opacity": 0.045, "sx": 18.0, "sy": 5.0, "offset": 0.035, "tint": Color("#a0a5ad"), "z": 4}
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

func _build_canopy_shadows() -> void:
    var pixel := _white_pixel()
    var anchors := [0.16, 0.43, 0.72, 0.91]
    for i in range(anchors.size()):
        var shadow := Sprite2D.new()
        shadow.name = "SwayingTreeShadow_%02d" % i
        shadow.texture = pixel
        shadow.centered = false
        shadow.position = Vector2(_world_width * float(anchors[i]), 340.0 + float(i % 2) * 18.0)
        shadow.scale = Vector2(330.0 if i % 2 == 0 else 270.0, 190.0)
        shadow.z_index = 8
        shadow.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
        var material := ShaderMaterial.new()
        material.shader = Shader.new()
        material.shader.code = SHADOW_SHADER
        material.set_shader_parameter("seed", float(i) * 2.17)
        material.set_shader_parameter("sway", 0.018 + float(i % 2) * 0.009)
        shadow.material = material
        add_child(shadow)

func _build_ambient_lights() -> void:
    var light_texture := _make_organic_light_texture()
    var positions := [0.20, 0.51, 0.82]
    for i in range(positions.size()):
        var light := PointLight2D.new()
        light.name = "EnvironmentalBounceLight_%02d" % i
        light.texture = light_texture
        light.texture_scale = 1.75 if i == 1 else 1.45
        light.color = Color("#9aacc5") if i != 1 else Color("#c1a58d")
        light.energy = 0.20 if i != 1 else 0.16
        light.range_item_cull_mask = 2
        light.shadow_enabled = false
        light.position = Vector2(_world_width * float(positions[i]), 275.0 if i != 1 else 310.0)
        add_child(light)
        _lights.append(light)

func _make_organic_light_texture() -> Texture2D:
    var image := Image.create(128, 128, false, Image.FORMAT_RGBA8)
    var center := Vector2(63.5, 63.5)
    for y in range(128):
        for x in range(128):
            var delta := Vector2(float(x), float(y)) - center
            var radius := delta.length() / 63.5
            var angle := atan2(delta.y, delta.x)
            var irregularity := 0.035 * sin(angle * 5.0 + 0.8) + 0.022 * sin(angle * 9.0 - 1.1)
            var adjusted_radius := maxf(0.0, radius + irregularity)
            var falloff := 1.0 - smoothstep(0.10, 1.0, adjusted_radius)
            var alpha := pow(maxf(falloff, 0.0), 2.15)
            image.set_pixel(x, y, Color(1.0, 1.0, 1.0, alpha))
    return ImageTexture.create_from_image(image)

func _make_dust_texture() -> Texture2D:
    var image := Image.create(16, 16, false, Image.FORMAT_RGBA8)
    var center := Vector2(7.5, 7.5)
    for y in range(16):
        for x in range(16):
            var radius := center.distance_to(Vector2(float(x), float(y))) / 7.5
            var alpha := pow(maxf(0.0, 1.0 - smoothstep(0.10, 1.0, radius)), 2.0)
            image.set_pixel(x, y, Color(1.0, 1.0, 1.0, alpha))
    return ImageTexture.create_from_image(image)

func _build_dust_field() -> void:
    _dust = CPUParticles2D.new()
    _dust.name = "DriftingEnvironmentalDust"
    _dust.amount = 34
    _dust.lifetime = 9.0
    _dust.preprocess = 3.0
    _dust.emitting = true
    _dust.local_coords = false
    _dust.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
    _dust.emission_rect_extents = Vector2(560.0, 245.0)
    _dust.direction = Vector2(-0.25, -0.12)
    _dust.spread = 58.0
    _dust.gravity = Vector2(-0.18, -0.10)
    _dust.initial_velocity_min = 2.0
    _dust.initial_velocity_max = 7.5
    _dust.angular_velocity_min = -12.0
    _dust.angular_velocity_max = 12.0
    _dust.scale_amount_min = 0.45
    _dust.scale_amount_max = 1.25
    _dust.color = Color(0.70, 0.77, 0.86, 0.22)
    _dust.texture = _make_dust_texture()
    _dust.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
    _dust.visibility_rect = Rect2(-700.0, -400.0, 1400.0, 800.0)
    _dust.z_index = 50
    add_child(_dust)

func follow_camera(camera_position: Vector2) -> void:
    if is_instance_valid(_dust):
        _dust.global_position = camera_position

func _process(delta: float) -> void:
    _elapsed += delta
    for i in range(_lights.size()):
        var light := _lights[i]
        if not is_instance_valid(light):
            continue
        var slow_breath := sin(_elapsed * (0.31 + float(i) * 0.07) + float(i) * 1.9)
        var gentle_flicker := sin(_elapsed * (2.7 + float(i) * 0.8) + float(i) * 2.4)
        light.energy = (0.20 if i != 1 else 0.16) + slow_breath * 0.012 + gentle_flicker * 0.006
