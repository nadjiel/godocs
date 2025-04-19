# TODO: Add documentation about the default AST used in the Godocs plugin.
## [AbstractSyntaxNode] models a node used to represent an Abstract Syntax.
## 
## This class is the basic piece of data that constructs an
## [b]Abstract Syntax Tree[/b] (AST).[br]
## To represent different kinds of information, this class is extended by the
## [AbstractSyntaxTextNode] and [AbstractSyntaxTagNode] classes.
class_name AbstractSyntaxNode
extends RefCounted

func _to_string() -> String:
	return "<>"

## The [method translate] method can be used with the help of a
## [SyntaxTranslator] to transform the [b]Abstract Syntax[/b]
## represented by this AST, into a [b]Concrete Syntax[/b].[br]
## [i]See also [SyntaxTranslator][/i].
func translate(translator: SyntaxTranslator) -> String:
	return ""
