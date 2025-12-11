extends Node2D

@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D
@export var move_speed := 3
@export var distance := 160 
@export var move_horizontal := true

var platform_center = 16
var follow:= Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_platform()


func _physics_process(_delta: float) -> void:
	animatable_body_2d.position = animatable_body_2d.position.lerp(follow, 0.5)

func move_platform():
	var move_direction = distance * (Vector2.RIGHT if move_horizontal else Vector2.UP)
	var duration = move_direction.length()/ float(move_speed * platform_center)
	var tween :Tween = get_tree().create_tween().set_loops().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "follow", move_direction, duration)
	tween.tween_property(self, "follow", Vector2.ZERO, duration)
	
