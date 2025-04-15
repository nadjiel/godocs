## The [SyntaxInterpreter] class can help parsing text into
## Abstract Syntax Trees.
## 
## This class can be seen as an [b]interface[/b] meant to be extended in order
## to have real functionality.[br]
## Its purpose is to realize the parsing of [b]different syntaxes[/b]
## (depending on the implementation realized) to an
## [b]Abstract Syntax Tree[/b] (ASTs).[br]
## See also [AbstractSyntaxNode] to understand better about ASTs and the
## [BBCodeSyntaxInterpreter] implementation to have a concrete example.
class_name SyntaxInterpreter
extends RefCounted

## The [method interpret] method is supposed to be [b]overriden[/b]
## in order to define how a [SyntaxInterpreter] should perform the
## interpretation of a text in [b]another syntax[/b] to an
## [b]Abstract Syntax Tree[/b].
func interpret(text: String) -> AbstractSyntaxTagNode: return null
