extends CharacterBody2D
class_name FighterBase

# Shared state and combat timing for David and every street rival.
enum State { IDLE, WALK, ATTACK, HURT, KNOCKDOWN, KO }
const ATTACK_ANTICIPATION := 0.05
const ATTACK_EXTENSION := 0.08
const ATTACK_FOLLOW_THROUGH := 0.07
const ATTACK_RECOVERY := 0.06
const ATTACK_DURATION := ATTACK_ANTICIPATION + ATTACK_EXTENSION + ATTACK_FOLLOW_THROUGH + ATTACK_RECOVERY

var fighter_state: State = State.IDLE
var state_time := 0.0
var attack_elapsed := 0.0
var attack_anticipation := ATTACK_ANTICIPATION
var attack_hit_confirmed := false
var combo_step := 1

func tick_fighter(delta: float) -> void:
	if fighter_state == State.ATTACK:
		attack_elapsed += delta
		state_time = maxf(0.0, state_time - delta)
		if state_time <= 0.0:
			fighter_state = State.IDLE
	elif fighter_state == State.HURT or fighter_state == State.KNOCKDOWN:
		state_time = maxf(0.0, state_time - delta)
		if state_time <= 0.0:
			fighter_state = State.IDLE
	if fighter_state == State.IDLE and velocity.length() > 1.0:
		fighter_state = State.WALK
	elif fighter_state == State.WALK and velocity.length() <= 1.0:
		fighter_state = State.IDLE

func begin_attack(step: int = 1, anticipation: float = ATTACK_ANTICIPATION) -> bool:
	if not can_start_attack():
		return false
	combo_step = clampi(step, 1, 3)
	attack_anticipation = maxf(0.0, anticipation)
	fighter_state = State.ATTACK
	state_time = attack_anticipation + ATTACK_EXTENSION + ATTACK_FOLLOW_THROUGH + ATTACK_RECOVERY
	attack_elapsed = 0.0
	attack_hit_confirmed = false
	# Preserve the current movement vector so an attack can be performed
	# while advancing; the main controller keeps applying directional input.
	return true

func attack_window_active() -> bool:
	# Match the extension and follow-through frames exactly. The visual attack
	# has anticipation (0.05s), extension (0.08s), hold (0.07s), recovery (0.06s).
	return fighter_state == State.ATTACK and attack_elapsed >= attack_anticipation and attack_elapsed <= attack_anticipation + ATTACK_EXTENSION + ATTACK_FOLLOW_THROUGH

func mark_attack_hit() -> void:
	attack_hit_confirmed = true

func receive_hit(knockback: Vector2, knockdown: bool = false) -> void:
	if fighter_state == State.KO:
		return
	fighter_state = State.KNOCKDOWN if knockdown else State.HURT
	state_time = 0.32 if knockdown else 0.18
	velocity = knockback

func can_move() -> bool:
	return fighter_state == State.IDLE or fighter_state == State.WALK or fighter_state == State.ATTACK

func can_start_attack() -> bool:
	return fighter_state == State.IDLE or fighter_state == State.WALK
