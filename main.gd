extends Node

@export var mob_scene: PackedScene
@export var shield_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	get_tree().call_group("shields", "queue_free")

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("¿Listo Aventurero?")
	$Music.play()
	
	spawn_shield()
	get_tree().call_group("mobs", "queue_free")	
	
func spawn_shield():
	var shield = shield_scene.instantiate()
	
	var screen_size = get_viewport().get_visible_rect().size
	var x = randi_range(50, screen_size.x - 50)
	var y = randi_range(50, screen_size.y - 50)
	shield.position = Vector2(x, y)
	
	add_child(shield)
	
	shield.picked_up.connect(_on_shield_picked)
	shield.tree_exited.connect(_on_shield_gone)
	
func _on_shield_picked():
	$Player.activate_shield()
	
	$ShieldRespawnTimer.wait_time = 10
	$ShieldRespawnTimer.start()
	
func _on_shield_gone():
	if not $Player.shielded:
		$ShieldRespawnTimer.wait_time = 10
		$ShieldRespawnTimer.start()
		

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_shield_respawn_timer_timeout() -> void:
	spawn_shield()
