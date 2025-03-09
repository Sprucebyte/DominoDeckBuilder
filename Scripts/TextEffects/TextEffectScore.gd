extends RichTextEffect
class_name TextEffectScore

var bbcode = "score"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = Color.ROYAL_BLUE
	return true