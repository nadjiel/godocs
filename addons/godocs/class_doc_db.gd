
class_name ClassDocDB
extends RefCounted

var data: Array[XMLDocument] = []

var current_class: String = ""

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

func get_current_class_document() -> XMLDocument:
	return get_class_document(current_class)

func set_class_document(document: XMLDocument) -> void:
	data.append(document)

func get_class_document_list() -> Array[XMLDocument]:
	return data

func get_class_inheritage(
	descendent_name: String = current_class,
	inheritage: Array[String] = []
) -> Array[String]:
	var document: XMLDocument = get_class_document(descendent_name)
	
	if document == null:
		return inheritage
	
	var descendent_node: XMLNode = document.root
	var parent_name: String = descendent_node.attributes.get("inherits", "")
	
	if parent_name == "":
		return inheritage
	
	inheritage.append(parent_name)
	
	return get_class_inheritage(parent_name, inheritage)
