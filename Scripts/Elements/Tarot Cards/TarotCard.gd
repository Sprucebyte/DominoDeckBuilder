extends Card
class_name TarotCard

func _process(delta: float) -> void:
	super(delta)
	if selected:
		if Input.is_key_pressed(KEY_E):
			if canUse():
				use()
				selected = false

func canUse() -> bool:
	return true

func use():
	SignalBus.TarotCardUsed.emit(self)
	destroy()
	pass

func destroy():
	container.remove(self)
	queue_free()
