extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	body.emit_signal("coletou_moeda")
	$AnimatedSprite2D.play("desappearing")


func _on_animated_sprite_2d_animation_finished() -> void:
	print("caboy")
	if $AnimatedSprite2D.animation == "desappearing":
		queue_free()
