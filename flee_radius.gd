extends Node2D

@onready var sprite: Sprite2D = $Icon

var minimum_distance: float = 300.0
var speed: float = 500.0


func _process(delta: float) -> void:
	var away: Vector2 = sprite.position - get_global_mouse_position()
	var distance: float = away.length()
	var direction: Vector2 = away.normalized()

	if distance <= minimum_distance:
		var new_speed = speed * (1.0 - distance / minimum_distance)
		print(new_speed)
		sprite.position += direction * new_speed * delta
