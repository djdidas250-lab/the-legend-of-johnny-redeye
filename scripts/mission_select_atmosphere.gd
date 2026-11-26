extends Control
class_name MissionSelectAtmosphere

const ATMOSPHERE_SHADER := """
shader_type canvas_item;
render_mode unshaded, blend_mix;

void fragment() {
    vec2 uv = UV;
    float t = TIME;
    float vignette = smoothstep(0.02, 0.82, distance(uv, vec2(0.5, 0.48)));
    float edge_dark = 0.20 + vignette * 0.24;
    float night_haze = 0.13 + 0.09 * sin(uv.y * 3.8 + t * 0.12);

    // Broad low-frequency fog banks roll across the complete map, not just
    // the center. Their upper edges drift slowly and remain softly blended.
    float wave_a = sin(uv.x * 8.0 + t * 0.075 + sin(uv.y * 5.0 - t * 0.045) * 1.7);
    float wave_b = sin(uv.x * 13.0 - t * 0.052 + sin(uv.y * 3.2 + t * 0.035) * 1.3);
    float wave_c = cos(uv.x * 4.1 + t * 0.031 + sin(uv.y * 7.0 - t * 0.025));
    float rolling = 0.50 + wave_a * 0.23 + wave_b * 0.16 + wave_c * 0.11;
    float lower_bank = smoothstep(0.34, 0.76, uv.y);
    float drifting_wisp = exp(-pow((uv.y - (0.49 + sin(uv.x * 5.0 + t * 0.035) * 0.12)) * 5.2, 2.0));
    float fog = lower_bank * (0.045 + smoothstep(0.22, 0.84, rolling) * 0.15)
        + drifting_wisp * 0.045;

    vec3 shadow_tint = vec3(0.012, 0.018, 0.035);
    vec3 fog_tint = vec3(0.43, 0.49, 0.61);
    vec3 haze_tint = mix(shadow_tint, vec3(0.035, 0.046, 0.075), clamp(night_haze, 0.0, 1.0));
    vec3 overlay = mix(haze_tint, fog_tint, clamp(fog, 0.0, 0.22));
    float alpha = clamp(edge_dark + night_haze * 0.36 + fog, 0.0, 0.58);
    COLOR = vec4(overlay, alpha);
}
"""

var _embers: CPUParticles2D

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    _build_fog_and_haze()
    _build_embers()
    resized.connect(_on_resized)
    _on_resized()

func _build_fog_and_haze() -> void:
    var haze := ColorRect.new()
    haze.name = "RollingNightFogAndHaze"
    haze.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    haze.mouse_filter = Control.MOUSE_FILTER_IGNORE
    var shader := Shader.new()
    shader.code = ATMOSPHERE_SHADER
    var material := ShaderMaterial.new()
    material.shader = shader
    haze.material = material
    add_child(haze)

func _build_ember_texture() -> Texture2D:
    var image := Image.create(24, 32, false, Image.FORMAT_RGBA8)
    var center := Vector2(11.5, 15.5)
    for y in range(32):
        for x in range(24):
            var distance := (Vector2(x, y) - center).length()
            var glow := 1.0 - smoothstep(1.0, 15.0, distance)
            var core := 1.0 - smoothstep(0.0, 5.0, distance)
            image.set_pixel(x, y, Color(1.0, 0.30 + core * 0.48, 0.055, glow * 0.92))
    return ImageTexture.create_from_image(image)

func _build_embers() -> void:
    _embers = CPUParticles2D.new()
    _embers.name = "MissionSelectFloatingEmbers"
    _embers.amount = 58
    _embers.lifetime = 7.5
    _embers.preprocess = 5.0
    _embers.emitting = true
    _embers.local_coords = true
    _embers.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
    _embers.direction = Vector2(-0.10, -1.0)
    _embers.spread = 24.0
    _embers.gravity = Vector2(3.0, -8.0)
    _embers.initial_velocity_min = 8.0
    _embers.initial_velocity_max = 24.0
    _embers.angular_velocity_min = -28.0
    _embers.angular_velocity_max = 28.0
    _embers.scale_amount_min = 0.38
    _embers.scale_amount_max = 0.95
    _embers.color = Color(1.0, 0.43, 0.12, 0.82)
    _embers.texture = _build_ember_texture()
    _embers.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
    _embers.z_index = 2
    add_child(_embers)

func _on_resized() -> void:
    if not is_instance_valid(_embers):
        return
    var viewport_size := size
    _embers.position = viewport_size * 0.5
    # The emission rectangle spans the entire mission-select canvas so
    # embers drift along both sides and across the full map.
    _embers.emission_rect_extents = viewport_size * 0.5
