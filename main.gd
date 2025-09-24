extends Node2D
@onready var left: Sprite2D = $left
@onready var right: Sprite2D = $right
@onready var rotator_right: Sprite2D = $rotator_right
@onready var rotator_left: Sprite2D = $rotator_left
@onready var camera_2d: Camera2D = $Camera2D

@export var dist_r: float = 50.0
@export var dist_l: float = 100.0
@export var speed_r: float = 2.0
@export var speed_l:float = 5.0

var angle: float = 0
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
	rotator_left.transform = transform_node(Transform2D(), delta, dist_l, speed_l, left)
	rotator_right.transform = transform_node(Transform2D(), delta, dist_r, speed_r, right)
	detect_colision()

func transform_node(t,delta, dist, speed, node):
	#Traslation
	var offset = Vector2(cos(angle), sin(angle)) * dist
	t.origin = node.position + offset
	#Rotation
	angle += speed * delta	
	t.x.x = cos(angle)
	t.y.y = cos(angle)
	t.x.y = sin(angle)
	t.y.x = -sin(angle)
	#scale
	t.x*= SCALE
	t.y*= SCALE	
	return t

func detect_colision():
	if rotator_left.position.distance_to(rotator_right.position) < 32:
		print("🌍💥🌍 COLISIÓN!")
