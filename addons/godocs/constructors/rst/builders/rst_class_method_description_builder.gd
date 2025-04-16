
class_name RSTClassMethodDescriptionBuilder
extends RSTDocBuilder

var bbcode: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()

var rst: SyntaxTranslator = RSTSyntaxTranslator.new()

func make_method_description(
	method_node: XMLNode,
	db: ClassDocDB
) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var document_name: String = document.root.attributes.get("name", "")
	var description_node: XMLNode = method_node.get_child_by_name("description")
	var return_node: XMLNode = method_node.get_child_by_name("return")
	var param_nodes: Array[XMLNode] = method_node.get_children_by_name("param")
	
	var description: String = description_node.content
	
	if description == "":
		return ""
	
	var return_type: String = return_node.attributes.get("type", "")
	var name: String = method_node.attributes.get("name", "")
	var full_name: String = ".".join([ document_name, name ])
	var param_list: Array[Dictionary] = []
	param_list.assign(param_nodes.map(
		func(param_node: XMLNode) -> Dictionary[String, String]:
			var result: Dictionary[String, String] = {}
			result.assign(param_node.attributes)
			
			return result
	))
	
	var label_output: String = RSTSyntaxTranslator.make_code_member_label(".".join([ document_name, name ]))
	var signature_output: String = RSTSyntaxTranslator.make_heading(make_method_signature(
		full_name,
		return_type,
		param_list
	), 3)
	var description_output: String = ( bbcode
		.interpret(description)
		.translate(rst)
	)
	description_output = autocomplete_code_members(description_output, db)
	
	var result: String = "\n%s\n\n%s" % [
		label_output,
		signature_output
	]
	
	result += "\n%s\n\n" % description_output
	
	return result

func make_method_descriptions(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var methods_node: XMLNode = document.root.get_child_by_name("methods")
	
	if methods_node == null:
		return ""
	
	var result: String = ""
	
	for method_node: XMLNode in methods_node.children:
		var description_output: String = make_method_description(
			method_node,
			db
		)
		
		if description_output == "":
			continue
		
		result += description_output
	
	return result

func build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	
	if class_node.get_child_by_name("methods") == null:
		return ""
	
	var title := "Method descriptions"
	
	var title_output: String = RSTSyntaxTranslator.make_heading(title, 2)
	var descriptions_output: String = make_method_descriptions(db)
	
	if descriptions_output.is_empty():
		return ""
	
	var result: String = "\n%s\n%s" % [
		title_output,
		descriptions_output
	]
	
	return result
