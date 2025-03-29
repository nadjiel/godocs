
class_name DocBuilder
extends RefCounted

static func build_all(builders: Array[DocBuilder], db: ClassDocDB) -> String:
	return builders.reduce((
		func(prev: String, next: DocBuilder) -> String:
			return prev + next._build(db)
	), "")

func _build(db: ClassDocDB) -> String: return ""
