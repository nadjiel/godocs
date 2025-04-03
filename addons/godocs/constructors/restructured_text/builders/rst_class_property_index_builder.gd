
class_name RSTClassPropertyIndexBuilder
extends RSTDocBuilder

func make_property_row(
	member_node: XMLNode,
	document_name: String
) -> Array[String]:
	var result: Array[String] = []
	
	var type: String = member_node.attributes.get("type", "")
	var name: String = member_node.attributes.get("name", "")
	var default_value: String = member_node.attributes.get("default", "")
	
	var type_output: String = make_ref(
		type,
		make_class_label(type)
	)
	var name_output: String = make_ref(
		name,
		make_class_property_label(document_name, name)
	)
	var default_value_output: String = ""
	
	if default_value != "" and default_value != "<unknown>":
		default_value_output = make_code_block(default_value)
	
	result.append(type_output)
	result.append(name_output)
	result.append(default_value_output)
	
	return result

func make_property_matrix(document: XMLDocument) -> Array[Array]:
	var class_node: XMLNode = document.root
	var document_name: String = class_node.attributes.get("name", "")
	var members_node: XMLNode = class_node.get_child_by_name("members")
	
	if members_node == null:
		return []
	
	var data_matrix: Array[Array] = []
	
	for member_node: XMLNode in members_node.children:
		data_matrix.append(make_property_row(member_node, document_name))
	
	return data_matrix

func _build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	
	if class_node.get_child_by_name("members") == null:
		return ""
	
	var title := "Property index"
	var title_size: int = title.length()
	var index: Array[Array] = make_property_matrix(document)
	
	var title_output: String = title
	var underline_output: String = "-".repeat(title_size)
	var index_output: String = make_table(index, [], { "widths": "auto" })
	
	var result: String = "\n%s\n%s\n\n%s\n" % [
		title_output,
		underline_output,
		index_output
	]
	
	return result
