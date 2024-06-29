extends Sprite2D
class_name Wheel


@export var parent_vehicule: Vehicule
@export var maximum_wheel_bump_time: float = 1

var frame_amount: int


func _ready() -> void:
	var rand = RandomNumberGenerator.new()
	frame_amount = hframes * vframes - 1 # frames start with an index of 0 therefore the '-1'
	frame = rand.randi_range(0, frame_amount)


func _process(_delta: float) -> void:
	if(parent_vehicule.speed > 0): # Truck is rolling
		next_frame()


func hit_bump() -> void:
	offset.y -= 1
	await get_tree().create_timer(clampf(maximum_wheel_bump_time - parent_vehicule.speed, 0, maximum_wheel_bump_time)).timeout
	offset.y += 1


func next_frame() -> void:
	frame = (frame + 1) % frame_amount
