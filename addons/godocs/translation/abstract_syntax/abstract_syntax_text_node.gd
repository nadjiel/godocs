
class_name AbstractSyntaxTextNode
extends AbstractSyntaxNode

var content: String = ""

func _init(content: String) -> void:
	self.content = content

func _to_string() -> String:
	return '"%s"' % content

func translate(translator: SyntaxTranslator) -> String:
	return translator.translate_text(self)
