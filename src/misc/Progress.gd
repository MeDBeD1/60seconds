extends Control

var score: int = 0


func _on_Timer_timeout():
	$ProgressBar.value += 1
	if $ProgressBar.value >= 600:
		get_tree().change_scene("res://src/scenes/Victory.tscn")
