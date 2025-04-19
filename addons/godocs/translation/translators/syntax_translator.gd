## The [SyntaxTranslator] class can help translating
## [b]Abstract Syntax Trees[/b].
## 
## This class is meant to be extended in order to have real functionality.[br]
## Its purpose is to realize the translation of [b]Abstract Syntax Trees[/b]
## (ASTs) to [b]different syntaxes[/b], according to the
## implementation realized.[br]
## See also [AbstractSyntaxNode], to understand better about ASTs,
## and [RSTSyntaxTranslator] to see a concrete example of a [SyntaxTranslator].
class_name SyntaxTranslator
extends RefCounted

## The [method translate_text] method is supposed to be [b]overriden[/b]
## in order to define how a [SyntaxTranslator] should perform the
## translation of an [AbstractSyntaxTextNode] from an
## [b]Abstract Syntax Tree[/b] to [b]another syntax[/b].
func translate_text(node: AbstractSyntaxTextNode) -> String:
	return ""

## The [method translate_tag] method is supposed to be [b]overriden[/b]
## in order to define how a [SyntaxTranslator] should perform the
## translation of an [AbstractSyntaxTagNode] from an
## [b]Abstract Syntax Tree[/b] to [b]another syntax[/b].
func translate_tag(node: AbstractSyntaxTagNode) -> String:
	return ""
