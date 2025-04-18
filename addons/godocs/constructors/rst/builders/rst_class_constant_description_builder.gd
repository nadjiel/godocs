
class_name RSTClassConstantDescriptionBuilder
extends RSTDocBuilder

var _bbcode: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()

var _rst: SyntaxTranslator = RSTSyntaxTranslator.new()

func build(db: ClassDocDB) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	
	var title: String = "Constant descriptions"
	
	var title_output: String = RSTSyntaxTranslator.make_heading(title, 2)
	var descriptions_output: String = make_member_descriptions(
		"constants",
		_make_constant_description,
		db,
	)
	
	if descriptions_output.is_empty():
		return ""
	
	var result: String = "\n%s\n%s" % [
		title_output,
		descriptions_output
	]
	
	return result

func _make_constant_description(
	constant_node: XMLNode,
	db: ClassDocDB
) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	var doc_name: String = doc.root.attributes.get("name", "")
	var description: String = constant_node.content
	var is_enum_member: bool = not constant_node.attributes.get("enum", "").is_empty()
	
	if description == "" or is_enum_member:
		return ""
	
	var name: String = constant_node.attributes.get("name", "")
	var full_name: String = ".".join([ doc_name, name ])
	var value: String = constant_node.attributes.get("value", "")
	var signature: String = make_property_signature(
		full_name, "", value, false, false
	)
	
	var label_output := RSTSyntaxTranslator.make_code_member_label(full_name)
	var signature_output := RSTSyntaxTranslator.make_heading(signature, 3)
	var description_output: String = _bbcode\
		.interpret(description)\
		.translate(_rst)
	description_output = autocomplete_code_member_refs(description_output, db)
	
	var result: String = "\n%s\n\n%s\n%s\n\n" % [
		label_output,
		signature_output,
		description_output,
	]
	
	return result
