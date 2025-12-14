extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label_coins: Label = $ui/CanvasLayer/coins
@onready var r_spell_point: Marker2D = $r_spell_point
@onready var l_spell_point: Marker2D = $l_spell_point
@onready var hp_bar: ProgressBar = $ui/CanvasLayer/hp_bar

var shoot = preload("res://shoot.tscn")
var screen_limit_horizontal:int

var hp := 1
var direction:int = 0
var is_jumping:bool = false
var is_falling:bool = false

var can_shoot:bool = false

signal tomou_dano
signal coletou_moeda
signal coletou_cogumelo
signal coletou_fireflower

func set_animation():
	var anim := "idle"
	if is_jumping:
		anim = "jumping"
	elif not is_on_floor():
		anim = "falling"
	elif direction:
		anim = "running"
	animation_player.play(anim)
	
func adicionar_moeda():
	Global.coins +=1
	label_coins.text = str(Global.coins)+"x"
	print(Global.coins)
	
func crescer():
	var tween := get_tree().create_tween()
	tween.tween_property(self,"scale",Vector2(1.5,1.5),1)
	
func pode_atirar():
	can_shoot = true

func _ready() -> void:
	label_coins.text = str(Global.coins)+"x"
	screen_limit_horizontal = $Camera2D.limit_right-32
	
	tomou_dano.connect(perder_vida)
	coletou_moeda.connect(adicionar_moeda)
	coletou_cogumelo.connect(crescer)
	coletou_fireflower.connect(pode_atirar)

func perder_vida():
	hp-=1
	hp_bar.value = hp
	if hp<=0:
		get_tree().change_scene_to_file("res://morte.tscn")
	else:
		var tween:= get_tree().create_tween()
		var tween_knockback := get_tree().create_tween().set_parallel()
		tween.tween_property(self, "velocity", Vector2(-100,-80), 0.6)
		tween.tween_property(self, "modulate", Color.RED, 0.5)
		tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	
func _process(delta: float) -> void:
	set_animation()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("atacking") and can_shoot:
		var new_shoot = shoot.instantiate()
		if sprite_2d.flip_h:
			new_shoot.direction = -1
			new_shoot.global_position = l_spell_point.global_position
		else:
			new_shoot.global_position = r_spell_point.global_position
		get_tree().root.add_child(new_shoot)
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


func _on_portal_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
