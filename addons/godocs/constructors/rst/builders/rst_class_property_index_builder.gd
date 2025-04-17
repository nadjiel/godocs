## Creates a RST section with a table listing the properties of a class.
## 
## The [RSTClassPropertyIndexBuilder] is capable of creating a [String] with
## a [b]section in Restructured Text[/b] syntax listing the properties
## of a class stored in a [ClassDocDB].[br]
## The format of the output generated by the
## [method RSTClassPropertyIndexBuilder.build] method is as follows:
## [codeblock lang=rst]
## 
## Property index
## ==============
## 
## .. table::
##    :widths: auto
## 
##    +-------------------------------+---------------------------------------------+----------+
##    | :ref:`String <godocs_String>` | :ref:`property_a <godocs_Class_property_a>` | ``""``   |
##    +-------------------------------+---------------------------------------------+----------+
##    | :ref:`bool <godocs_bool>`     | :ref:`property_b <godocs_Class_property_b>` | ``true`` |
##    +-------------------------------+---------------------------------------------+----------+
## 
## [/codeblock]
## [i]See also: [RSTDocBuilder] and [ClassDocDB].[/i]
class_name RSTClassPropertyIndexBuilder
extends RSTDocBuilder

## The [method build] method uses the information contained in a [ClassDocDB]
## passed via the [param db] parameter to build a [b]section[/b]
## for the documentation of the [b]class pointed by it[/b], with
## a list with information about that class' properties.[br]
## The format of the output of this method is described in the documentation
## of this class, the [RSTClassPropertyIndexBuilder].
func build(db: ClassDocDB) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	var class_node: XMLNode = doc.root
	
	var title := "Property index"
	var index: Array[Array] = _make_property_matrix(doc)
	
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

func _make_property_row(
	member_node: XMLNode,
	doc_name: String
) -> Array[String]:
	var result: Array[String] = []
	
	var type: String = member_node.attributes.get("type", "")
	var name: String = member_node.attributes.get("name", "")
	var full_name: String = ".".join([ doc_name, name ])
	var default_value: String = member_node.attributes.get("default", "")
	
	var type_output := RSTSyntaxTranslator.make_code_member_type_ref(type)
	var name_output := RSTSyntaxTranslator.make_code_member_ref(full_name, name)
	var default_value_output: String = ""
	
	if not default_value.is_empty():
		default_value_output = RSTSyntaxTranslator.make_code(default_value)
	
	result.append(type_output)
	result.append(name_output)
	result.append(default_value_output)
	
	return result

func _make_property_matrix(doc: XMLDocument) -> Array[Array]:
	var class_node: XMLNode = doc.root
	var doc_name: String = class_node.attributes.get("name", "")
	var members_node: XMLNode = class_node.get_child_by_name("members")
	
	if members_node == null:
		return []
	
	var data_matrix: Array[Array] = []
	
	for member_node: XMLNode in members_node.children:
		data_matrix.append(_make_property_row(member_node, doc_name))
	
	return data_matrix
