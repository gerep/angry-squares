extends Area2D

var direction: Vector2
var speed: float = 400.0


func _process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return

	position += direction * speed * delta
