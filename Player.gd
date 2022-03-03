extends Area2D

signal movement(pos)

var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
"left": Vector2.LEFT,
"up": Vector2.UP,
"down": Vector2.DOWN}
onready var ray = $RayCast2D
onready var tween = $Tween
export var speed = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	if tween.is_active():
		return # Ignore inputs while tween is active
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.cast_to = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		move_tween(inputs[dir])
		emit_signal("movement", position)
		
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Coin_area_entered(area: Area2D):
	var coin: Area2D = get_parent().get_node("Coin")
	var knight: Area2D = get_parent().get_node("Knight")
	coin.queue_free()
	knight.queue_free()


func _on_Knight_area_entered(area):
	print("Hit!")
	var knight: Area2D = get_parent().get_node("Knight")
	knight.queue_free()
	queue_free()
