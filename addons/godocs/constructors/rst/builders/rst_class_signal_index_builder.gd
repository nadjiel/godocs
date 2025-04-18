class_name RSTClassSignalIndexBuilder
extends RSTDocBuilder

func build(db: ClassDocDB) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = doc.root
	
	var title := "Signal index"
	var index: Array[Array] = make_member_matrix(
		"signals",
		_make_signal_row,
		doc,
	)
	
	if index.is_empty():
		return ""
	
	var title_output: String = RSTSyntaxTranslator.make_heading(title, 2)
	var index_output: String = RSTSyntaxTranslator.make_table(
		index, [], { "widths": "auto" }
	)
	
	var result: String = "\n%s\n%s" % [
		title_output,
		index_output
	]
	
	return result

func _make_signal_row(
	signal_node: XMLNode,
	doc_name: String,
) -> Array[String]:
	var result: Array[String] = []
	
	var param_nodes: Array[XMLNode] = signal_node.get_children_by_name("param")
	
	var name: String = signal_node.attributes.get("name", "")
	var full_name: String = ".".join([ doc_name, name ])
	
	var param_list: Array[Dictionary] = []
	
	for param_node: XMLNode in param_nodes:
		param_list.append(param_node.attributes)
	
	var signature_output: String = make_method_signature(
		full_name, "", param_list
	)
	
	result.append(signature_output)
	
	return result
