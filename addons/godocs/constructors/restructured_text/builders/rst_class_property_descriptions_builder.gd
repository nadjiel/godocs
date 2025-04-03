
class_name RSTClassPropertyDescriptionsBuilder
extends RSTDocBuilder

func make_property_description(
	member_node: XMLNode,
	document: XMLDocument
) -> String:
	var document_name: String = document.root.attributes.get("name", "")
	var description: String = member_node.content
	
	if description == "":
		return ""
	
	var type: String = member_node.attributes.get("type", "")
	var name: String = member_node.attributes.get("name", "")
	var default_value: String = member_node.attributes.get("default", "")
	
	var label_output: String = make_class_property_label(document_name, name)
	var type_output: String = make_type_ref(type)
	var name_output: String = name
	var default_value_output: String = ""
	var description_output: String = description
	
	if default_value != "" and default_value != "<unknown>":
		default_value_output = make_code_block(default_value)
	
	var result: String = "\n%s\n\n%s %s" % [
		label_output,
		type_output,
		name_output
	]
	
	if default_value_output != "":
		result += " = %s" % default_value_output
	
	result += "\n\n%s\n" % description_output
	
	return result

func make_properties_descriptions(document: XMLDocument) -> String:
	var members_node: XMLNode = document.root.get_child_by_name("members")
	
	if members_node == null:
		return ""
	
	var result: String = ""
	
	for member_node: XMLNode in members_node.children:
		var description_output: String = make_property_description(
			member_node,
			document
		)
		
		if description_output == "":
			continue
		
		result += description_output
	
	return result

func _build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	
	var title := "Property descriptions"
	var title_size: int = title.length()
	
	var title_output: String = title
	var underline_output: String = "-".repeat(title_size)
	var descriptions_output: String = make_properties_descriptions(document)
	
	if descriptions_output == "":
		return ""
	
	var result: String = "\n%s\n%s\n\n%s\n" % [
		title_output,
		underline_output,
		descriptions_output
	]
	
	return result
