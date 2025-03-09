extends RichTextEffect
class_name TextEffectMult

var bbcode = "mult"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = Color.RED
	return true