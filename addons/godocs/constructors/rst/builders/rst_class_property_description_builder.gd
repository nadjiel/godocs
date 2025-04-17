
class_name RSTClassPropertyDescriptionBuilder
extends RSTDocBuilder

var bbcode: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()

var rst: SyntaxTranslator = RSTSyntaxTranslator.new()

func make_property_description(
	member_node: XMLNode,
	db: ClassDocDB
) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var document_name: String = document.root.attributes.get("name", "")
	var description: String = member_node.content
	
	if description == "":
		return ""
	
	var type: String = member_node.attributes.get("type", "")
	var name: String = member_node.attributes.get("name", "")
	var full_name: String = ".".join([ document_name, name ])
	var default_value: String = member_node.attributes.get("default", "")
	
	var label_output: String = RSTSyntaxTranslator.make_code_member_label(full_name)
	var signature_output: String = make_property_signature(
		full_name, type, default_value
	)
	var description_output: String = ( bbcode
		.interpret(description)
		.translate(rst)
	)
	description_output = autocomplete_code_member_refs(description_output, db)
	
	var result: String = "\n%s\n\n%s" % [
		label_output,
		signature_output
	]
	
	result += "\n\n%s\n\n" % description_output
	
	return result

func make_properties_descriptions(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var members_node: XMLNode = document.root.get_child_by_name("members")
	
	if members_node == null:
		return ""
	
	var result: String = ""
	
	for member_node: XMLNode in members_node.children:
		var description_output: String = make_property_description(
			member_node,
			db
		)
		
		if description_output == "":
			continue
		
		result += description_output
	
	return result

func build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	
	var title := "Property descriptions"
	
	var title_output: String = RSTSyntaxTranslator.make_heading(title, 2)
	var descriptions_output: String = make_properties_descriptions(db)
	
	if descriptions_output == "":
		return ""
	
	var result: String = "\n%s\n%s" % [
		title_output,
		descriptions_output
	]
	
	return result
