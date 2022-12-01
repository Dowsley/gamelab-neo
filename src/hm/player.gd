extends KinematicBody2D

const TARGET_FPS := 60
const ACCELERATION := 8
const MAX_SPEED := 100
const FRICTION := 10
const AIR_RESISTANCE := 1
const GRAVITY := 5
const JUMP_FORCE := 140
const DASH_FORCE := 140

onready var animation_player := $AnimatedSprite

# Control members
var h_motion_input := 0.0
var jump_just_pressed_input := false
var jump_just_released_input := false
var jumps_left := 2

# Movement members
var motion := Vector2.ZERO

# Animation member
var double_jump_anim_flag := false

func loop_controls():
	h_motion_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	jump_just_pressed_input = Input.is_action_just_pressed("ui_up")
	jump_just_released_input = Input.is_action_just_released("ui_up")

func loop_movement(delta: float):
	if h_motion_input != 0:
		motion.x += h_motion_input * ACCELERATION * delta * TARGET_FPS
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		animation_player.flip_h = h_motion_input < 0
	
	motion.y += GRAVITY * delta * TARGET_FPS
	
	if is_on_floor():
		if h_motion_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
			
		if jump_just_pressed_input:
			motion.y = -JUMP_FORCE
			jumps_left -= 1
	else:
		if jump_just_released_input and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
			
		if jump_just_pressed_input and jumps_left == 1:
			motion.y = -JUMP_FORCE
			jumps_left -= 1
		
		if h_motion_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
	
	motion = move_and_slide(motion, Vector2.UP)

func loop_animation():
	if is_on_floor():
		jumps_left = 2
		double_jump_anim_flag = false
		if h_motion_input != 0:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
	else:
		if jumps_left == 0 and not double_jump_anim_flag:
			animation_player.frame = 0
			double_jump_anim_flag = true
		animation_player.play("jump")

func _physics_process(delta):
	loop_controls()
	loop_movement(delta)
	loop_animation()
