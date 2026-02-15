extends Node2D

const PROJECTILE = preload("uid://bfhn2axuuf4cq")

var viewpot_center: Vector2


func _ready() -> void:
	viewpot_center = get_viewport_rect().get_center()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var projectile_scene = PROJECTILE.instantiate()
		projectile_scene.direction = (get_global_mouse_position() - viewpot_center).normalized()
		add_child(projectile_scene)
		projectile_scene.position = viewpot_center
