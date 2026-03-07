extends Node2D

@onready var sprite: Sprite2D = $Icon

var speed: float = 100.0
var wander_angle: float = 0.0
var circle_distance: float = 60.0
var circle_radius: float = 30.0
var velocity: Vector2 = Vector2(1, 0) * 100.0


func _process(delta: float) -> void:
	# Nudge the wander angle randomly each frame
	wander_angle += randf_range(-0.5, 0.5)

	# Imaginary circle ahead of the sprite
	var forward: Vector2 = velocity.normalized()
	var circle_center: Vector2 = sprite.position + forward * circle_distance

	# Pick a point on the rim of the circle
	var target_point: Vector2 = circle_center + Vector2(cos(wander_angle), sin(wander_angle)) * circle_radius

	# Steer toward that point
	var desired_velocity: Vector2 = (target_point - sprite.position).normalized() * speed
	var steering: Vector2 = desired_velocity - velocity
	steering = steering.limit_length(3.0)
	velocity += steering
	velocity = velocity.limit_length(speed)

	sprite.position += velocity * delta
	sprite.rotation = velocity.angle()

	# Wrap around screen edges
	var screen: Vector2 = get_viewport_rect().size
	if sprite.position.x > screen.x: sprite.position.x = 0
	if sprite.position.x < 0: sprite.position.x = screen.x
	if sprite.position.y > screen.y: sprite.position.y = 0
	if sprite.position.y < 0: sprite.position.y = screen.y
