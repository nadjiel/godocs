
class_name RSTClassDescriptionBuilder
extends RSTDocBuilder

func build(db: ClassDocDB) -> String:
	var bbcode: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()
	var rst: SyntaxTranslator = RSTSyntaxTranslator.new()
	
	var document: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = document.root
	var description_node: XMLNode = class_node.get_child_by_name("description")
	
	var description: String = description_node.content
	
	if description == "":
		return ""
	
	var title := "Description"
	
	var title_output: String = make_heading(title, 2)
	var description_output: String = ( bbcode
		.interpret(description)
		.translate(rst)
	)
	description_output = fix_short_code_member_refs(description_output, db)
	
	var result: String = "\n%s\n%s\n" % [
		title_output,
		description_output
	]
	
	return result
