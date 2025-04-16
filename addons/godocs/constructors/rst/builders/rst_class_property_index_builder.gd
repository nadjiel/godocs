
class_name RSTClassPropertyIndexBuilder
extends RSTDocBuilder

func make_property_row(
	member_node: XMLNode,
	document_name: String
) -> Array[String]:
	var result: Array[String] = []
	
	var type: String = member_node.attributes.get("type", "")
	var name: String = member_node.attributes.get("name", "")
	var full_name: String = ".".join([ document_name, name ])
	var default_value: String = member_node.attributes.get("default", "")
	
	var type_output: String = make_code_member_type_ref(type)
	var name_output: String = make_code_member_ref(full_name, name)
	var default_value_output: String = ""
	
	if default_value != "" and default_value != "<unknown>":
		default_value_output = RSTSyntaxTranslator.make_code(default_value)
	
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

func build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	
	if class_node.get_child_by_name("members") == null:
		return ""
	
	var title := "Property index"
	var index: Array[Array] = make_property_matrix(document)
	
	var title_output: String = RSTSyntaxTranslator.make_heading(title, 2)
	var index_output: String = RSTSyntaxTranslator.make_table(index, [], { "widths": "auto" })
	
	var result: String = "\n%s\n%s\n" % [
		title_output,
		index_output
	]
	
	return result
