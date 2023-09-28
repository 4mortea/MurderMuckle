extends Area2D

signal hit

export var speed = 400.0
var screen_size = Vector2.ZERO
# Add this variable to hold the clicked position.
var target = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Change the target whenever a touch event happens.
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position


func _process(delta):
	var velocity = Vector2()
	# Move towards the target and stop when close.
	if position.distance_to(target) > 10:
		velocity = target - position
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp (position.x,0, screen_size.x)
	position.y = clamp (position.y,0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "Right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "Up"
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.flip_v = velocity.y > 0


func start(new_position):
	position = new_position
	# Initial target is the start position.
	target = new_position
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hit")
