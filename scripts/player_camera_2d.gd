extends Camera2D

var cameraShakeNoise: FastNoiseLite

func _ready():
	cameraShakeNoise = FastNoiseLite.new()

func StartCameraShake(intensity: float):
	var cameraOffset = cameraShakeNoise.get_noise_1d(Time.get_ticks_msec()) * intensity
	self.offset.x = cameraOffset
	self.offset.y = cameraOffset
