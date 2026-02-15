extends CharacterBody2D

@onready var detection_area: Area2D = $DetectionArea
@onready var collision_area: Area2D = $CollisionArea
@onready var infight_timer: Timer = $InfightTimer
@onready var infight_interval_timer: Timer = $InfightIntervalTimer
@onready var evade_area: Area2D = $EvadeArea

enum STATES { HUNTING, INFIGHTING, EVADING }

var max_speed: float = 100.0
var max_steer_force: float = 10.0
var separation_weight: float = 1000.0
var slowing_radius: float = 400.0
var target_position: Vector2
var infight_target: Node2D
var can_infight: bool = true
var evade_direction: Vector2 = Vector2.ZERO

var current_state: STATES = STATES.HUNTING


func _ready() -> void:
	collision_area.body_entered.connect(_on_collision_area_body_entered)
	infight_interval_timer.timeout.connect(_on_infight_interval_timeout)
	infight_timer.timeout.connect(_on_infight_timer_timeout)
	evade_area.area_entered.connect(_on_evade_area_area_entered)
	evade_area.area_exited.connect(_on_evade_area_area_exited)


func _physics_process(_delta: float) -> void:
	match current_state:
		STATES.HUNTING:
			target_position = get_global_mouse_position()
			modulate = Color.WHITE
		STATES.INFIGHTING:
			target_position = infight_target.position
			modulate = Color.RED
		STATES.EVADING:
			modulate = Color.YELLOW

	var to_target: Vector2 = target_position - position
	var seek_steering: Vector2 = _calculate_seek(to_target)
	var separation_steering: Vector2 = _calculate_separation()
	var evade_steering: Vector2 = _calculate_evade()
	var total_steering: Vector2 = (
		seek_steering + separation_steering * separation_weight + evade_steering
	)

	velocity += total_steering
	velocity = velocity.limit_length(max_speed)
	rotation = lerp_angle(rotation, velocity.angle(), 0.15)

	move_and_slide()


func _calculate_seek(to_target: Vector2) -> Vector2:
	if current_state == STATES.EVADING:
		return Vector2.ZERO

	var distance: float = to_target.length()
	var desired_speed: float = max_speed
	if distance <= slowing_radius:
		desired_speed = max_speed * (distance / slowing_radius)
	if desired_speed < 5.0:
		desired_speed = 0.0

	var desired_velocity: Vector2 = to_target.normalized() * desired_speed
	var steering: Vector2 = desired_velocity - velocity
	return steering.limit_length(max_steer_force)


func _calculate_separation() -> Vector2:
	if current_state == STATES.INFIGHTING:
		return Vector2.ZERO

	var force: Vector2 = Vector2.ZERO

	for body in detection_area.get_overlapping_bodies():
		if body == self:
			continue
		var away: Vector2 = position - body.position
		var distance: float = away.length()
		if distance < 1.0:
			continue
		var repulsion: Vector2 = away.normalized() / distance
		force += repulsion

	return force


func _calculate_evade() -> Vector2:
	if current_state != STATES.EVADING:
		return Vector2.ZERO

	var desired_velocity: Vector2 = evade_direction * max_speed
	var steering: Vector2 = desired_velocity - velocity
	return steering.limit_length(max_steer_force)


func _on_collision_area_body_entered(body: Node2D) -> void:
	if body == self or current_state == STATES.INFIGHTING:
		return

	if not can_infight:
		return

	if current_state == STATES.HUNTING:
		current_state = STATES.INFIGHTING
		infight_target = body
		infight_timer.start()
		infight_interval_timer.start()
		can_infight = false


func _on_infight_timer_timeout() -> void:
	current_state = STATES.HUNTING
	infight_target = null


func _on_infight_interval_timeout() -> void:
	can_infight = true


func _on_evade_area_area_entered(projectile: Area2D) -> void:
	if current_state == STATES.EVADING:
		return

	var projectile_direction: Vector2 = projectile.direction
	var perpendicular_left: Vector2 = Vector2(-projectile_direction.y, projectile_direction.x)
	var perpendicular_right: Vector2 = Vector2(projectile_direction.y, -projectile_direction.x)

	var to_enemy: Vector2 = position - projectile.position
	if to_enemy.dot(perpendicular_left) > 0:
		evade_direction = perpendicular_left
	else:
		evade_direction = perpendicular_right

	current_state = STATES.EVADING


func _on_evade_area_area_exited(_projectile: Area2D) -> void:
	current_state = STATES.HUNTING
	evade_direction = Vector2.ZERO
