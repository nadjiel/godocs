
class_name RSTClassEnumDescriptionBuilder
extends RSTDocBuilder

var _bbcode: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()

var _rst: SyntaxTranslator = RSTSyntaxTranslator.new()

func build(db: ClassDocDB) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	
	var title: String = "Enumeration descriptions"
	
	var title_output: String = RSTSyntaxTranslator.make_heading(title, 2)
	var descriptions_output: String = _make_enum_descriptions(db)
	
	if descriptions_output.is_empty():
		return ""
	
	var result: String = "\n%s\n%s" % [
		title_output,
		descriptions_output
	]
	
	return result

func _make_enum_constant_description(
	constant_node: XMLNode,
	db: ClassDocDB,
) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	var doc_name: String = doc.root.attributes.get("name", "")
	var description: String = constant_node.content
	var enum_name: String = constant_node.attributes.get("enum")
	
	if description.is_empty():
		return ""
	
	var name: String = constant_node.attributes.get("name", "")
	var full_name: String = ".".join([ doc_name, enum_name, name ])
	var value: String = constant_node.attributes.get("value", "")
	var signature: String = make_property_signature(
		full_name, "", value, false, false
	)
	
	var label_output := RSTSyntaxTranslator.make_code_member_label(full_name)
	var signature_output := RSTSyntaxTranslator.make_heading(signature, 4)
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

func _group_constants_by_enum(
	constants_node: XMLNode
) -> Dictionary[String, Array]:
	var result: Dictionary[String, Array] = {}
	
	for node: XMLNode in constants_node.children:
		var enum_name: String = node.attributes.get("enum", "")
		
		if not result.has(enum_name):
			result[enum_name] = []
		
		result[enum_name].append(node)
	
	return result

func _make_enum_description(
	enum_name: String,
	constant_nodes: Array[XMLNode],
	db: ClassDocDB,
) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = doc.root
	var doc_name: String = class_node.attributes.get("name")
	var full_enum_name: String = ".".join([ doc_name, enum_name ])
	
	var label_output := RSTSyntaxTranslator\
		.make_code_member_label(full_enum_name)
	var title_output: String = RSTSyntaxTranslator\
		.make_heading(enum_name, 3)
	
	var descriptions_output: String = ""
	
	for node: XMLNode in constant_nodes:
		var description_output: String = _make_enum_constant_description(node, db)
		
		if description_output.is_empty():
			continue
		
		descriptions_output += description_output
	
	var result: String = "\n%s\n\n%s\n%s" % [
		label_output,
		title_output,
		descriptions_output
	]
	
	return result

func _make_enum_descriptions(db: ClassDocDB) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = doc.root
	var doc_name: String = class_node.attributes.get("name")
	var constants_node: XMLNode = class_node.get_child_by_name("constants")
	
	if constants_node == null:
		return ""
	
	var enum_map := _group_constants_by_enum(constants_node)
	var enum_list: Array[String] = []
	enum_list.assign(enum_map.keys())
	
	var result: String = ""
	
	for enum_name: String in enum_list:
		if enum_name.is_empty():
			continue
		
		var enum_constant_nodes: Array[XMLNode] = []
		enum_constant_nodes.assign(enum_map[enum_name])
		
		result += _make_enum_description(enum_name, enum_constant_nodes, db)
	
	return result
