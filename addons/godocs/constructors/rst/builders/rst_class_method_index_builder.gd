
class_name RSTClassMethodIndexBuilder
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
	var type_output: String = make_type_ref(type)
	
	var result: String = "%s: %s" % [
		name_output,
		type_output
	]
	
	return result

func make_method_row(
	method_node: XMLNode,
	document_name: String
) -> Array[String]:
	var result: Array[String] = []
	
	var return_node: XMLNode = method_node.get_child_by_name("return")
	var param_nodes: Array[XMLNode] = method_node.get_children_by_name("param")
	
	var name: String = method_node.attributes.get("name", "")
	var return_type: String = return_node.attributes.get("type", "")
	
	var return_type_output: String = make_type_ref(return_type)
	var name_output: String = make_class_method_ref(document_name, name)
	var params_output: String = make_params_output(param_nodes)
	var signature_output: String = "%s(%s)" % [
		name_output,
		params_output
	]
	
	result.append(return_type_output)
	result.append(signature_output)
	
	return result

func make_method_matrix(document: XMLDocument) -> Array[Array]:
	var class_node: XMLNode = document.root
	var document_name: String = class_node.attributes.get("name", "")
	var methods_node: XMLNode = class_node.get_child_by_name("methods")
	
	if methods_node == null:
		return []
	
	var matrix: Array[Array] = []
	
	for method_node: XMLNode in methods_node.children:
		matrix.append(make_method_row(method_node, document_name))
	
	return matrix

func _build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	
	if class_node.get_child_by_name("methods") == null:
		return ""
	
	var title := "Method index"
	var title_size: int = title.length()
	var index: Array[Array] = make_method_matrix(document)
	
	var title_output: String = title
	var underline_output: String = "-".repeat(title_size)
	var index_output: String = make_table(index, [], { "widths": "auto" })
	
	var result: String = "\n%s\n%s\n\n%s\n" % [
		title_output,
		underline_output,
		index_output
	]
	
	return result
