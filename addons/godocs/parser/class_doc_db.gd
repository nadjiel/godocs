
class_name ClassDocDB
extends RefCounted

const MEMBER_TYPES: Array[String] = [
	"members",
	"methods",
	"signals",
	"constants",
	"annotations",
	"operators",
	"theme_items",
]

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

func get_class_member_dict(
	member_types: Array[String] = [],
	owner_name: String = current_class
) -> Dictionary[String, Array]:
	var doc: XMLDocument = get_class_document(owner_name)
	
	if doc == null:
		return {}
	
	var result: Dictionary[String, Array] = {}
	
	for member_type: String in MEMBER_TYPES:
		if not member_type in member_types and not member_types.is_empty():
			continue
		
		var members_node: XMLNode = doc.root.get_child_by_name(member_type)
		
		if members_node == null:
			continue
		
		var member_list: Array[String] = []
		
		for member_node: XMLNode in members_node.children:
			if not member_node.attributes.has("name"):
				continue
			
			member_list.append(member_node.attributes.get("name", ""))
		
		result[member_type] = member_list
	
	return result
