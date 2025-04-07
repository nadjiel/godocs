
class_name AbstractSyntaxNode
extends RefCounted

func _to_string() -> String:
	return "<>"

func translate(translator: SyntaxTranslator) -> String:
	return ""
