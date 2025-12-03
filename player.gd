extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
var screen_limit_horizontal:int

var direction:int = 0
var is_jumping:bool = false
var is_falling:bool = false
func set_animation():
	var anim := "idle"
	if is_jumping:
		anim = "jumping"
	elif not is_on_floor():
		anim = "falling"
	elif direction:
		anim = "running"
	animation_player.play(anim)
	
func _ready() -> void:
	screen_limit_horizontal = $Camera2D.limit_right-32
	print(screen_limit_horizontal)
	
func _process(delta: float) -> void:
	set_animation()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		is_jumping = true
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction>0:
			sprite_2d.flip_h = false
		elif direction<0:
			sprite_2d.flip_h = true
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	position.x = clamp(position.x,0,screen_limit_horizontal)
	move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jumping":
		is_jumping = false
