extends CanvasModulate

@export var day_night_cycle: bool = true

@export var day: bool = false


func _ready():
	if(day_night_cycle):
		$AnimationPlayer.play("day_night")
	else:
		if(day):
			self.visible = false
