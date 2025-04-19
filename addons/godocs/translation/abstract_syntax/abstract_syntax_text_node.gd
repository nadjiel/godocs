## [AbstractSyntaxTextNode] represents a component of an AST that stores
## bare text.
## 
## This class is used to represent a [b]basic[/b] text [String] without any
## additional informations associated.[br]
## In order for this class to be instantiated it needs a [param content], which
## is stored as the text it represents.[br]
## [i]See also [AbstractSyntaxNode][/i] 
class_name AbstractSyntaxTextNode
extends AbstractSyntaxNode

## The [member content] property stores the [b]text[/b] associated with
## this node.
var content: String = ""

func _init(content: String) -> void:
	self.content = content

func _to_string() -> String:
	return '"%s"' % content

## The [method translate] method can be used with the help of a
## [SyntaxTranslator] implementation to obtain the equivalent [b]translation[/b]
## of the [member content] of this node in that [b]other syntax[/b].[br]
## [i]See also [SyntaxTranslator][/i].
func translate(translator: SyntaxTranslator) -> String:
	return translator.translate_text(self)
