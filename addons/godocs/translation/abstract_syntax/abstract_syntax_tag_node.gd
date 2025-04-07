
class_name AbstractSyntaxTagNode
extends AbstractSyntaxNode

var name: String = ""

var params: Dictionary[String, String] = {}

var children: Array[AbstractSyntaxNode] = []

func _init(
	name: String,
	children: Array[AbstractSyntaxNode] = [],
	params: Dictionary[String, String] = {},
) -> void:
	self.name = name
	self.children = children
	self.params = params

func _to_string() -> String:
	var result: String = "<%s" % self.name
	
	if not children.is_empty():
		result += "\n%s\n" % stringify_children().indent("\t")
	
	result += ">"
	
	return result

func translate(translator: SyntaxTranslator) -> String:
	return translator.translate_tag(self)

func stringify_children() -> String:
	return children.reduce((
		func(prev: String, next: AbstractSyntaxNode) -> String:
			if prev == "":
				return str(next)
			
			return prev + ",\n" + str(next)
	), "")
