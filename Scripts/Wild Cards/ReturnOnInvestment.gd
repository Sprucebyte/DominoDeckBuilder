extends WildCard

func activate() -> void:
	addScore(Score.Instance.money)
	shake()
	return