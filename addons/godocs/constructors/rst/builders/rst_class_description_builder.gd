## Creates a RST section with the description of a class.
## 
## The [RSTClassDescriptionBuilder] is capable of creating a [String] with
## a [b]section in Restructured Text[/b] syntax describing a class stored
## in a [ClassDocDB].[br]
## The format of the output generated by the
## [method RSTClassDescriptionBuilder.build] method is as follows:
## [codeblock lang=rst]
## 
## Description
## ===========
## 
## Description.
## 
## [/codeblock]
## [i]See also: [RSTDocBuilder] and [ClassDocDB].[/i]
class_name RSTClassDescriptionBuilder
extends RSTDocBuilder

## The [method build] method uses the information contained in a [ClassDocDB]
## passed via the [param db] parameter to build a [b]section[/b]
## for the documentation of the [b]class pointed by it[/b], with
## the description from that class.[br]
## The format of the output of this method is described in the documentation
## of this class, the [RSTClassDescriptionBuilder].
func build(db: ClassDocDB) -> String:
	var bbcode: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()
	var rst: SyntaxTranslator = RSTSyntaxTranslator.new()
	
	var doc: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = doc.root
	var description_node: XMLNode = class_node.get_child_by_name("description")
	
	var description: String = description_node.content
	
	if description == "":
		return ""
	
	var title := "Description"
	
	var title_output: String = RSTSyntaxTranslator.make_heading(title, 2)
	var description_output: String = bbcode\
		.interpret(description)\
		.translate(rst)
	description_output = autocomplete_code_member_refs(description_output, db)
	
	var result: String = "\n%s\n%s\n" % [
		title_output,
		description_output
	]
	
	return result
