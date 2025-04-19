
extends GdUnitTestSuite

var builder: DocBuilder = RSTClassMethodDescriptionBuilder.new()

var expected: String = r'
Method descriptions
===================


.. _godocs_Class_method_a:

:ref:`String <godocs_String>` method_a\(\)
------------------------------------------

Description of the method_a.


.. _godocs_Class_method_b:

:ref:`bool <godocs_bool>` method_b\(\)
--------------------------------------

Description of the method_b.

'

func test_build_creates_expected_string() -> void:
	var doc := XMLDocument.new()
	
	var class_node := XMLNode.new()
	class_node.attributes.set("name", "Class")
	
	var methods_node := XMLNode.new()
	methods_node.name = "methods"
	
	var method_a_node := XMLNode.new()
	method_a_node.name = "method"
	method_a_node.attributes.set("name", "method_a")
	var return_method_a_node := XMLNode.new()
	return_method_a_node.name = "return"
	return_method_a_node.attributes.set("type", "String")
	method_a_node.children.append(return_method_a_node)
	var description_method_a_node := XMLNode.new()
	description_method_a_node.name = "description"
	description_method_a_node.content = "Description of the method_a."
	method_a_node.children.append(description_method_a_node)
	
	var method_b_node := XMLNode.new()
	method_b_node.name = "method"
	method_b_node.attributes.set("name", "method_b")
	var return_method_b_node := XMLNode.new()
	return_method_b_node.name = "return"
	return_method_b_node.attributes.set("type", "bool")
	method_b_node.children.append(return_method_b_node)
	method_b_node.content = "Description of the method_b."
	var description_method_b_node := XMLNode.new()
	description_method_b_node.name = "description"
	description_method_b_node.content = "Description of the method_b."
	method_b_node.children.append(description_method_b_node)
	
	methods_node.children.append(method_a_node)
	methods_node.children.append(method_b_node)
	
	class_node.children.append(methods_node)
	
	doc.root = class_node
	
	var db := ClassDocDB.new()
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = builder.build(db)
	
	assert_str(result).is_equal(expected)
