extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		GlobalSignal.emit_signal("climbing", true)
		


func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		GlobalSignal.emit_signal("climbing", false)




