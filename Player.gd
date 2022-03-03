extends Area2D

signal movement(pos)

var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
"left": Vector2.LEFT,
"up": Vector2.UP,
"down": Vector2.DOWN}
onready var ray = $RayCast2D
onready var tween = $Tween
onready var sprite = $AnimatedSprite
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
	else:
		var sfx = get_parent().get_node("ThudSfx")
		sfx.stream.loop = false
		sfx.play()
		squish_tween(inputs[dir])
		
func move_tween(dir):
	tween.interpolate_property(self, "position",
		position, position + dir * tile_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func squish_tween(dir: Vector2):
	tween.interpolate_property(sprite, "scale", 
	sprite.scale, sprite.scale + (dir.abs() * -0.5), 
	0.15, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "position",
	position, position + (dir * tile_size/2),
	0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	
	tween.interpolate_property(sprite, "scale", 
	sprite.scale + (dir.abs() * -0.5), sprite.scale, 
	0.15, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.15)
	tween.interpolate_property(self, "position",
	position + (dir * tile_size/2), position,
	0.1, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.1)
	tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Coin_area_entered(area: Area2D):
	var coin: Area2D = get_parent().get_node("Coin")
	var knight: Area2D = get_parent().get_node("Knight")
	var sfx: AudioStreamPlayer = get_parent().get_node("CoinSfx")
	sfx.stream.loop = false
	sfx.play()
	coin.queue_free()
	knight.queue_free()


func _on_Knight_area_entered(area):
	print("Hit!")
	var knight: Area2D = get_parent().get_node("Knight")
	var sfx: AudioStreamPlayer = get_parent().get_node("HitSfx")
	sfx.stream.loop = false
	sfx.play()
	knight.queue_free()
	queue_free()
