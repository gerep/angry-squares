extends Node2D

var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	var target = get_global_mouse_position()
	var direction = target - position
	#velocity = direction * 10
	velocity = direction.normalized() * 100
	position += velocity * delta
	queue_redraw()


func _draw() -> void:
	draw_line(Vector2.ZERO, velocity, Color.YELLOW, 5.0)
