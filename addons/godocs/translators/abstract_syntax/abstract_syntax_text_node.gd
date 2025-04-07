
class_name AbstractSyntaxTextNode
extends AbstractSyntaxNode

var content: String = ""

func _init(content: String) -> void:
	self.content = content

func _to_string() -> String:
	return '<"%s">' % content
