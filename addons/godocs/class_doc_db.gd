
class_name ClassDocDB
extends RefCounted

var db: Array[XMLDocument] = []

func _get_class_document_by_idx(idx: int) -> XMLDocument:
	if idx >= 0 and idx < db.size():
		return db[idx]
	
	return null

func get_class_document(name: String) -> XMLDocument:
	var idx: int = db.find_custom(
		func(document: XMLDocument) -> bool:
			return document.root.attributes.get("name", "") == name
	)
	
	return _get_class_document_by_idx(idx)
