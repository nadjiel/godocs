
class_name RSTClassMethodDescriptionsBuilder
extends RSTDocBuilder

func make_params_output(param_nodes: Array[XMLNode]) -> String:
	var params_output: String = ""
	
	for i: int in param_nodes.size():
		params_output += make_param_output(param_nodes[i])
		
		if i < param_nodes.size() - 1:
			params_output += ", "
	
	var result: String = params_output
	
	return result

func make_param_output(param_node: XMLNode) -> String:
	var name: String = param_node.attributes.get("name", "")
	var type: String = param_node.attributes.get("type", "")
	
	var name_output: String = name
	var type_output: String = make_code_member_type_ref(type)
	
	var result: String = "%s: %s" % [
		name_output,
		type_output
	]
	
	return result

func make_method_description(
	method_node: XMLNode,
	document: XMLDocument
) -> String:
	var document_name: String = document.root.attributes.get("name", "")
	var description_node: XMLNode = method_node.get_child_by_name("description")
	var return_node: XMLNode = method_node.get_child_by_name("return")
	var param_nodes: Array[XMLNode] = method_node.get_children_by_name("param")
	
	var description: String = description_node.content
	
	if description == "":
		return ""
	
	var return_type: String = return_node.attributes.get("type", "")
	var name: String = method_node.attributes.get("name", "")
	
	var label_output: String = make_code_member_label(".".join([ document_name, name ]))
	var return_type_output: String = make_code_member_type_ref(return_type)
	var name_output: String = name
	var params_output: String = make_params_output(param_nodes)
	var description_output: String = description
	
	var result: String = "\n%s\n\n%s %s(%s)" % [
		label_output,
		return_type_output,
		name_output,
		params_output
	]
	
	result += "\n\n%s\n" % description_output
	
	return result

func make_method_descriptions(document: XMLDocument) -> String:
	var methods_node: XMLNode = document.root.get_child_by_name("methods")
	
	if methods_node == null:
		return ""
	
	var result: String = ""
	
	for method_node: XMLNode in methods_node.children:
		var description_output: String = make_method_description(
			method_node,
			document
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
	var title_size: int = title.length()
	
	var title_output: String = title
	var underline_output: String = "-".repeat(title_size)
	var descriptions_output: String = make_method_descriptions(document)
	
	var result: String = "\n%s\n%s\n\n%s\n" % [
		title_output,
		underline_output,
		descriptions_output
	]
	
	return result
