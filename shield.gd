extends Area2D
class_name Shield

signal picked_up

@export var lifetime = 5.0
var blinking = false

func _ready():
	$LifeTimer.wait_time = lifetime
	$LifeTimer.start()

func blink():
	if blinking:
		$Sprite2D.visible = not $Sprite2D.visible
		await get_tree().create_timer(0.2).timeout
		blink()
	else:
		queue_free()

func _on_life_timer_timeout() -> void:
	blinking = true
	blink()


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		picked_up.emit()
		queue_free()
		$LifeTimer.stop()
