extends CharacterBody2D
class_name Vehicule


@onready var driver_seat_position = $DriverSeat.position

var wheels: Array = []
var speed: float = 0


func _ready() -> void:
	for wheel in $Wheels.get_children():
		wheels.append(wheel)
	wheels.sort_custom(func (a: Wheel, b: Wheel): return a.position.x < b.position.x)


func _on_door_body_entered(body):
	if body is Player:
		$Door/AnimatedSprite2D.play("open")
		Stack.row = {
			"id" = str(body.get_instance_id()),
			"text" = "Get in",
		}


func _on_door_body_exited(body):
	if body is Player:
		$Door/AnimatedSprite2D.play_backwards("open")
		Stack.row = {
			"id" = str(body.get_instance_id()),
			"text" = "",
		}
