extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.emit_signal("coletou_fireflower")
	$Area2D/AnimationPlayer.play("desappearing")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "desappearing":
		queue_free()
