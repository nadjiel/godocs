
class_name RSTClassHeadingBuilder
extends RSTDocBuilder

func make_inheritage_output(db: ClassDocDB) -> String:
	var inheritage: Array[String] = db.get_class_inheritage()
	
	var result: String = ""
	
	for parent: String in inheritage:
		var parent_output: String = make_code_member_ref(parent)
		
		if result == "":
			result = "%s %s" % [ make_bold("Inherits:"), parent_output ]
		else:
			result += " %s %s" % [ make_bold("<"), parent_output ]
	
	return result

func build(db: ClassDocDB) -> String:
	var bbcode: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()
	var rst: SyntaxTranslator = RSTSyntaxTranslator.new()
	
	var document: XMLDocument = db.get_current_class_document()
	
	if document == null:
		return ""
	
	var class_node: XMLNode = document.root
	var brief_description_node: XMLNode = class_node.get_child_by_name(
		"brief_description"
	)
	
	var name := class_node.attributes.get("name", "") as String
	var brief_description: String = brief_description_node.content
	
	var label_output: String = make_code_member_label(name)
	var title_output: String = make_heading(name, 1)
	var inheritage_output: String = make_inheritage_output(db)
	var brief_description_output: String = ( bbcode
		.interpret(brief_description)
		.translate(rst) )
	brief_description_output = fix_short_code_member_refs(
		brief_description_output,
		db
	)
	
	var result: String = "\n%s\n\n%s\n%s\n" % [
		label_output,
		title_output,
		inheritage_output
	]
	
	if brief_description_output != "":
		result += "\n%s\n" % brief_description_output
	
	return result
