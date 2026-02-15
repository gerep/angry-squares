extends Node2D

@onready var icon: Sprite2D = $Icon
@onready var icon_2: Sprite2D = $Icon2
@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var icon_label: Label = $Icon/Label
@onready var icon_2_label: Label = $Icon2/Label
@onready var icon_3: Sprite2D = $Icon3
@onready var icon_3_label: Label = $Icon3/Label


func _ready() -> void:
	var viewport = get_viewport_rect()
	icon_2.position = viewport.get_center()


func _process(_delta: float) -> void:
	var difference = icon.position - icon_2.position
	label.text = str(difference)
	label_2.text = str(difference.length())
	icon_label.text = str(icon.position)
	icon_2_label.text = str(icon_2.position)
	icon_3.position = icon_2.position + difference
	icon_3_label.text = str(icon_3.position)
	queue_redraw()


func _draw() -> void:
	var difference = icon.position - icon_2.position
	draw_line(icon.position, icon_2.position, Color.GREEN, 5.0)
	draw_line(icon_2.position, icon_2.position + difference.normalized() * 100, Color.RED, 5.0)
