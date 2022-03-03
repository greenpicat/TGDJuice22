extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
"left": Vector2.LEFT,
"up": Vector2.UP,
"down": Vector2.DOWN}
onready var tween = $Tween
export var speed = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_movement(pos: Vector2):
	if pos.x < position.x:
		move_tween(inputs["left"])
	elif pos.x > position.x:
		move_tween(inputs["right"])
	elif pos.y < position.y:
		move_tween(inputs["up"])
	elif pos.y > position.y:
		move_tween(inputs["down"])
		
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func _on_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()
