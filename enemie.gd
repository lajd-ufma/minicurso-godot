extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
signal tomou_dano
var hp:int = 3

func _ready() -> void:
	tomou_dano.connect(perder_vida)

func perder_vida():
	hp-=1
	$hp_bar.value = hp
	if hp<=0:
		$hp_bar.visible = false
		$AnimationPlayer.play("desappearing")
	else:
		var tween:= get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.RED, 0.5)
		tween.tween_property(self, "modulate", Color.WHITE, 0.5)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "desappearing":
		queue_free()
