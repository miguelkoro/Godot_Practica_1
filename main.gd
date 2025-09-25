extends Node2D
@onready var left: Sprite2D = $left
@onready var right: Sprite2D = $right
@onready var rotator_right: Sprite2D = $rotator_right
@onready var rotator_left: Sprite2D = $rotator_left
@onready var camera_2d: Camera2D = $Camera2D

@export_group("Propiedades")
@export var dist_r: float = 50.0
@export var dist_l: float = 100.0
@export var speed_r: float = 1
@export var speed_l:float = 7.0

var angle_l: float = 0
var angle_r: float = 0
const SCALE: float = 0.25

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			left.position = viewport_pos_to_world(event.position)
			camera_2d.position = viewport_pos_to_world(event.position)
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			right.position = viewport_pos_to_world(event.position)
			
func viewport_pos_to_world(event_pos: Vector2) -> Vector2:
	return get_viewport().get_canvas_transform().affine_inverse() * event_pos

func _process(delta: float) -> void:
	angle_l = transform_node(delta, dist_l, speed_l, left, rotator_left, angle_l)
	angle_r = transform_node(delta, dist_r, speed_r, right, rotator_right, angle_r)
	detect_colision()

func transform_node(delta, dist, speed, node, rotator, angle):	
	var t = Transform2D()
	#Transform
	var distance = Vector2(cos(angle), sin(angle)) * dist
	t.origin = node.position + distance
	#Rotation
	angle += speed * delta	
	t.x.x = cos(angle)
	t.y.y = cos(angle)
	t.x.y = sin(angle)
	t.y.x = -sin(angle)
	#scale
	t.x*= SCALE
	t.y*= SCALE	
	
	rotator.transform = t
	return angle


func detect_colision():
	if rotator_left.position.distance_to(rotator_right.position) < 32:
		print("🌍💥🌍 COLISIÓN!")
