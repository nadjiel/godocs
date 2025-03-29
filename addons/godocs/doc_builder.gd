
class_name DocBuilder
extends RefCounted

static func build(db: ClassDocDB, builders: Array[DocBuilder]) -> String:
	return builders.reduce((
		func(prev: String, next: DocBuilder) -> String:
			return prev + next._parse(db)
	), "")

func _parse(db: ClassDocDB) -> String: return ""
