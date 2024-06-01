extends Position2D

signal spawned(spawn)

export (PackedScene) var skeleton

onready var rng = RandomNumberGenerator.new()
onready var minTimer = 10.1
onready var maxTimer = 30.1
onready var SpawnCD = $SpawnCD

func _ready():
	rng.randomize()
	var my_random_number = rng.randf_range(minTimer, maxTimer)
	SpawnCD.wait_time = my_random_number
	SpawnCD.start()

func spawn():
	var spawling = skeleton.instance()
	
	add_child(spawling)
	spawling.set_as_toplevel(true)
	spawling.global_position = global_position
	
	emit_signal("spawned", spawling)
	return spawling


func _on_SpawnCD_timeout():
	rng.randomize()
	var my_random_number = rng.randf_range(0, maxTimer)
	spawn()
	SpawnCD.wait_time = my_random_number
	SpawnCD.start()
