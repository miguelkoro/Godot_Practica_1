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
	rotator_left.transform = transform_node(delta, dist_l, speed_l, left, "left")
	rotator_right.transform = transform_node(delta, dist_r, speed_r, right, "right")
	detect_colision()

func transform_node(delta, dist, speed, node, type) -> Transform2D:	
	var t = Transform2D()
	if(type=="left"): #Debo separarlo porque el angle es una variable global
		#Traslation
		var distance = Vector2(cos(angle_l), sin(angle_l)) * dist
		t.origin = node.position + distance
		#Rotation
		angle_l += speed * delta	
		t.x.x = cos(angle_l)
		t.y.y = cos(angle_l)
		t.x.y = sin(angle_l)
		t.y.x = -sin(angle_l)
	elif(type=="right"):
		#Traslation
		var distance = Vector2(cos(angle_r), sin(angle_r)) * dist
		t.origin = node.position + distance
		#Rotation
		angle_r += speed * delta	
		t.x.x = cos(angle_r)
		t.y.y = cos(angle_r)
		t.x.y = sin(angle_r)
		t.y.x = -sin(angle_r)
	#scale
	t.x*= SCALE
	t.y*= SCALE	
	return t


func detect_colision():
	if rotator_left.position.distance_to(rotator_right.position) < 32:
		print("🌍💥🌍 COLISIÓN!")
