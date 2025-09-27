extends Area2D

signal hit

@export var speed = 400
var screen_size 


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x +=1
	if Input.is_action_pressed("move_left"):
		velocity.x -=1
	if Input.is_action_pressed("move_up"):
		velocity.y -=1
	if Input.is_action_pressed("move_down"):
		velocity.y +=1
	
	if velocity.x > 0:
		$AnimatedSprite2D.play("right")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("left")
	elif velocity.y < 0:
		$AnimatedSprite2D.play("up")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("down")
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity.normalized() * delta * speed
	position = position.clamp(Vector2.ZERO, screen_size)
	
func _on_body_entered(_body) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
