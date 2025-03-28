extends RichTextEffect
class_name TextEffectMoney

var bbcode = "money"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = Color.YELLOW
	
	return true
