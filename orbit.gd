extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var distance: float = 200.0
var angle: float = 0.0
var speed: float = 2.0


func _process(delta: float) -> void:
	var target: Vector2 = get_global_mouse_position()

	# angle is an endless counter, always being incremented.
	angle += speed * delta

	# Using cos and sin, we are guaranteed to have values between -1 and 1.
	# They cycle after a full rotation.
	sprite.position = target + Vector2(cos(angle), sin(angle)) * distance

	# .angle() takes a vector and gives the angle. `cos/sin` take an angle and
	# gives a vector.
