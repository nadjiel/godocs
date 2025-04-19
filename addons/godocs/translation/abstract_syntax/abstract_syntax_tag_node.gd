## [AbstractSyntaxTagNode] represents a more complex component of an AST.
## 
## This class is used to represent a more [b]complex[/b] syntax component when
## compared with its sibling [AbstractSyntaxTextNode].[br]
## Making use of the [member name], [member params] and [member children]
## properties, this kind of Node can represent things like [b]URLs[/b],
## [b]Bold[/b], [b]Italics[/b] and a lot of other syntax markups.[br]
## In order for this class to be instantiated it needs a [param name] [String]
## which is stored in the [member name] property.[br]
## Optionally, the [member children] and [member params] can also be directly
## passed through constructor arguments.[br]
## [i]See also [AbstractSyntaxNode][/i] 
class_name AbstractSyntaxTagNode
extends AbstractSyntaxNode

## The [member name] property should store a unique [String]
## (within an [b]Abstract Syntax Tree[/b] context) informing
## what this Node stores and how it should be [b]translated[/b].[br]
## As an example, this plugin implements [AbstractSyntaxTagNode]s
## representing a [b]URL[/b] as having a [code]"link"[/code] name.[br]
## [i]See also [SyntaxTranslator][/i].
var name: String = ""

## The [member params] property can store key-value pairs representing
## important informations that can be used in the process of translation
## of this Node.[br]
## As an example, an Node representing a [b]URL[/b] could have a parameter
## indicating its target, similar to : [code]"target": "https://..."[/code].
## [i]See also [SyntaxTranslator][/i].
var params: Dictionary[String, String] = {}

## The [member children] property can store other [AbstractSyntaxNode]s that
## should hierarchically be children of this Node.[br]
## As an example, an Node representing a [b]URL[/b] could have its text
## represented as a child [AbstractSyntaxTextNode] with that text in its
## [member content] property.
## [i]See also [SyntaxTranslator][/i].
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
	
	if not params.is_empty():
		result += " %s" % _stringify_params()
	
	if not children.is_empty():
		result += "\n%s\n" % _stringify_children().indent("\t")
	
	result += ">"
	
	return result

## The [method translate] method can be used with the help of a
## [SyntaxTranslator] implementation to obtain the equivalent [b]translation[/b]
## of this Node in that [b]other syntax[/b].[br]
## [i]See also [SyntaxTranslator][/i].
func translate(translator: SyntaxTranslator) -> String:
	return translator.translate_tag(self)

func _stringify_params() -> String:
	var result: String = ""
	
	var keys: Array[String] = []
	keys.assign(params.keys())
	
	for i: int in keys.size():
		var key: String = keys[i]
		var value: String = params[key]
		
		result += "%s=%s" % [ key, value ]
		
		if i < keys.size() - 1:
			result += " "
	
	return result

func _stringify_children() -> String:
	return children.reduce((
		func(prev: String, next: AbstractSyntaxNode) -> String:
			if prev == "":
				return str(next)
			
			return prev + ",\n" + str(next)
	), "")
