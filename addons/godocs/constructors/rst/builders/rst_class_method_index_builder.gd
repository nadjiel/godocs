
class_name RSTClassMethodIndexBuilder
extends RSTDocBuilder

func make_method_row(
	method_node: XMLNode,
	document_name: String
) -> Array[String]:
	var result: Array[String] = []
	
	var return_node: XMLNode = method_node.get_child_by_name("return")
	var param_nodes: Array[XMLNode] = method_node.get_children_by_name("param")
	
	var name: String = method_node.attributes.get("name", "")
	var full_name: String = ".".join([ document_name, name ])
	var return_type: String = return_node.attributes.get("type", "")
	
	var param_list: Array[Dictionary] = []
	param_list.assign(param_nodes.map(
		func(param_node: XMLNode) -> Dictionary[String, String]:
			var d: Dictionary[String, String] = {}
			d.assign(param_node.attributes)
			
			return d
	))
	
	var return_type_output: String = make_code_member_type_ref(return_type)
	var signature_output: String = make_method_signature(
		full_name, "", param_list
	)
	
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

func build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	
	if class_node.get_child_by_name("methods") == null:
		return ""
	
	var title := "Method index"
	var index: Array[Array] = make_method_matrix(document)
	
	var title_output: String = RSTSyntaxTranslator.make_heading(title, 2)
	var index_output: String = RSTSyntaxTranslator.make_table(index, [], { "widths": "auto" })
	
	var result: String = "\n%s\n%s\n" % [
		title_output,
		index_output
	]
	
	return result
