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


#func _ready() -> void:
	#var t: Transform2D = Transform2D()
	
	#t.x.x=0
	#t.x.y=2
	#t.y.x
	#distance<32pixels=colision (Para la colision si se puede usar el position, para el resto hay que usar el transform)
	#_process para mirar si hay colision
	#Camera2D, left, right: puedes usar global_position
	#rotator srpites: NO puedes usar global_position
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
	#var t_left = Transform2D()
	rotator_left.transform = transform_node(Transform2D(), delta, dist_l, speed_l, left)
	rotator_right.transform = transform_node(Transform2D(), delta, dist_r, speed_r, right)
		#Traslation
	#t.origin += left.position+Vector2(150,150)
	
	#var t = Transform2D()
	#t.x *= 2
	#t.y *= 2
	#right.transform = t
	#rotator_left.transform = transform_rotate(delta)
	#speed_r =+ speed_r * delta
	
	

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
	
