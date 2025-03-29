
class_name ClassDocDB
extends RefCounted

var data: Array[XMLDocument] = []

func get_class_document_by_idx(idx: int) -> XMLDocument:
	if idx >= 0 and idx < data.size():
		return data[idx]
	
	return null

func get_class_document(name: String) -> XMLDocument:
	var idx: int = data.find_custom(
		func(document: XMLDocument) -> bool:
			return document.root.attributes.get("name", "") == name
	)
	
	return get_class_document_by_idx(idx)

func set_class_document(document: XMLDocument) -> void:
	data.append(document)

func get_class_document_list() -> Array[XMLDocument]:
	return data
