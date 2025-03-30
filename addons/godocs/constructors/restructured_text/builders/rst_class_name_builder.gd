
class_name RSTClassNameBuilder
extends RSTDocBuilder

func make_inheritage_output(db: ClassDocDB) -> String:
	var inheritage: Array[String] = db.get_class_inheritage()
	
	var result: String = ""
	
	for parent: String in inheritage:
		var parent_output: String = parse_class_name(parent)
		parent_output = make_ref(parent, "class_" + parent_output)
		
		if result == "":
			result = "%s %s" % [ make_bold("Inherits:"), parent_output ]
		else:
			result += " %s %s" % [ make_bold("<"), parent_output ]
	
	return result

func _build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	
	var name := class_node.attributes.get("name", "") as String
	var name_size: int = name.length()
	
	var label_output: String = make_label("class_%s" % parse_class_name(name))
	var title_output: String = name
	var underline_output: String = "=".repeat(name_size)
	var inheritage_output: String = make_inheritage_output(db)
	
	var result: String = "\n%s\n\n%s\n%s\n\n%s\n" % [
		label_output,
		title_output,
		underline_output,
		inheritage_output
	]
	
	return result
