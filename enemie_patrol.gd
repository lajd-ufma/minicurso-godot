extends CharacterBody2D


const SPEED = 100.0
var direction:int = 0
@onready var wall_detector: RayCast2D = $wall_detector
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("walking")
	direction = -1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if wall_detector.is_colliding():
		wall_detector.rotation_degrees += 180
		sprite_2d.flip_h = !sprite_2d.flip_h
		direction *= -1
	velocity.x = direction * SPEED

	move_and_slide()

func perder_vida():
	$AnimationPlayer.play("hurting")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	body.velocity.y = body.JUMP_VELOCITY
	perder_vida()


func _on_hitbox_body_entered(body: Node2D) -> void:
	body.emit_signal("tomou_dano")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurting":
		queue_free()
