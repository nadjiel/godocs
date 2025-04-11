
class_name RSTClassDescriptionBuilder
extends RSTDocBuilder

func _build(db: ClassDocDB) -> String:
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	var description_node: XMLNode = class_node.get_child_by_name("description")
	
	var description: String = description_node.content
	
	if description == "":
		return ""
	
	var title := "Description"
	var title_size: int = title.length()
	
	var title_output: String = title
	var underline_output: String = "-".repeat(title_size)
	var description_output: String = description
	
	var result: String = "\n%s\n%s\n\n%s\n" % [
		title_output,
		underline_output,
		description_output
	]
	
	return result
