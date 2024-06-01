extends Label


func _process(delta):
	self.text = str("Your score: ", Global.score)
