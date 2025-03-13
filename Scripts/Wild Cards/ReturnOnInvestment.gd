extends WildCard

func activate() -> void:
	addScore(Score.Instance.money)
	await shake()
	return