## Creates a RST heading describing a class.
## 
## The [RSTClassHeadingBuilder] is capable of creating a [String] with
## Restructured Text syntax describing a class stored in a [ClassDocDB].[br]
## [i]See also: [RSTDocBuilder] and [ClassDocDB].[/i]
class_name RSTClassHeadingBuilder
extends RSTDocBuilder

func _make_inheritage_output(db: ClassDocDB) -> String:
	var inheritage: Array[String] = db.get_class_inheritage()
	
	var result: String = ""
	
	for parent: String in inheritage:
		var parent_output: String = RSTSyntaxTranslator.make_code_member_ref(parent)
		
		if result == "":
			result = "%s %s" % [ RSTSyntaxTranslator.make_bold("Inherits:"), parent_output ]
		else:
			result += " %s %s" % [ RSTSyntaxTranslator.make_bold("<"), parent_output ]
	
	return result

## The [method build] method uses the information contained in a [ClassDocDB]
## passed via the [param db] parameter to build a [b]heading[/b]
## for the documentation of the [b]class pointed by it[/b].[br]
## The format of the output of this method is the following:
## [codeblock lang=rst]
## 
## .. _godocs_Class:
## 
## =====
## Class
## =====
## 
## **Inherits:** :ref:`SuperClass <godocs_SuperClass>` **<** :ref:`RefCounted <godocs_RefCounted>`
## 
## User created brief description.
## 
## [/codeblock]
func build(db: ClassDocDB) -> String:
	var bbcode: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()
	var rst: SyntaxTranslator = RSTSyntaxTranslator.new()
	
	var doc: XMLDocument = db.get_current_class_document()
	
	if doc == null:
		return ""
	
	var class_node: XMLNode = doc.root
	var brief_description_node: XMLNode = class_node.get_child_by_name(
		"brief_description"
	)
	
	var name: String = class_node.attributes.get("name", "")
	var brief_description: String = brief_description_node.content
	
	var label_output: String = RSTSyntaxTranslator.make_code_member_label(name)
	var title_output: String = RSTSyntaxTranslator.make_heading(name, 1)
	var inheritage_output: String = _make_inheritage_output(db)
	var brief_description_output: String = bbcode\
		.interpret(brief_description)\
		.translate(rst)
	brief_description_output = autocomplete_code_member_refs(
		brief_description_output,
		db,
	)
	
	var result: String = "\n%s\n\n%s\n%s\n" % [
		label_output,
		title_output,
		inheritage_output
	]
	
	if brief_description_output != "":
		result += "\n%s\n" % brief_description_output
	
	return result
