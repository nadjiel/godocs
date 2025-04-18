
class_name RSTClassSignalDescriptionBuilder
extends RSTDocBuilder

var _bbcode: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()

var _rst: SyntaxTranslator = RSTSyntaxTranslator.new()

func build(db: ClassDocDB) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = doc.root
	
	var title := "Signal descriptions"
	
	var title_output: String = RSTSyntaxTranslator.make_heading(title, 2)
	var descriptions_output: String = make_member_descriptions(
		"signals",
		_make_signal_description,
		db,
	)
	
	if descriptions_output.is_empty():
		return ""
	
	var result: String = "\n%s\n%s" % [
		title_output,
		descriptions_output
	]
	
	return result

func _make_signal_description(
	signal_node: XMLNode,
	db: ClassDocDB,
) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	var doc_name: String = doc.root.attributes.get("name", "")
	var description_node: XMLNode = signal_node.get_child_by_name("description")
	
	var param_nodes: Array[XMLNode] = signal_node.get_children_by_name("param")
	
	var description: String = description_node.content
	
	if description == "":
		return ""
	
	var name: String = signal_node.attributes.get("name", "")
	var full_name: String = ".".join([ doc_name, name ])
	var param_list: Array[Dictionary] = []
	
	for param_node: XMLNode in param_nodes:
		param_list.append(param_node.attributes)
	
	var signature: String = make_method_signature(
		full_name,
		"",
		param_list,
		false,
		false,
	)
	
	var label_output: String = RSTSyntaxTranslator\
		.make_code_member_label(full_name)
	var signature_output: String = RSTSyntaxTranslator\
		.make_heading(signature, 3)
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
