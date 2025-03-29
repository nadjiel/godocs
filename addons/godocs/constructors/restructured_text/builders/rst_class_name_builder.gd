
class_name RSTClassNameBuilder
extends DocBuilder

func get_inheritage_output(db: ClassDocDB) -> String:
	var inheritage: Array[String] = db.get_class_inheritage()
	
	var result: String = ""
	
	for name: String in inheritage:
		if result == "":
			result = "**Inherits:** :ref:`%s<class_%s>`" % [ name, name ]
		else:
			result += " **<** :ref:`%s<class_%s>`" % [ name, name ]
	
	return result

func _build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	
	var name := class_node.attributes.get("name", "") as String
	var name_size: int = name.length()
	
	var label_output: String = "_class_%s" % name
	var title_output: String = name + "\n"
	var underline_output: String = "=".repeat(name_size)
	var inheritage_output: String = get_inheritage_output(db)
	
	var result: String = "%s\n\n%s\n%s\n\n%s" % [
		label_output,
		title_output,
		underline_output,
		inheritage_output
	]
	
	return result
