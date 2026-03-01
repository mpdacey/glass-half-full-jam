extends Path2D

@export var line: Line2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not line:
		printerr(str("Ornament string for ", get_parent().name, " is missing given Line2D."))
		self.set_process(false)
		return 
	
	line.points = curve.get_baked_points()
