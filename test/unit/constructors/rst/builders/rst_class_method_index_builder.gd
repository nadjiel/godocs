
extends GdUnitTestSuite

var builder: DocBuilder = RSTClassMethodIndexBuilder.new()

var expected: String = r'
Method index
============

.. table::
   :widths: auto

   +-------------------------------+---------------------------------------------+
   | :ref:`String <godocs_String>` | :ref:`method_a <godocs_Class_method_a>`\(\) |
   +-------------------------------+---------------------------------------------+
   | :ref:`bool <godocs_bool>`     | :ref:`method_b <godocs_Class_method_b>`\(\) |
   +-------------------------------+---------------------------------------------+
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
	
	var method_b_node := XMLNode.new()
	method_b_node.name = "method"
	method_b_node.attributes.set("name", "method_b")
	var return_method_b_node := XMLNode.new()
	return_method_b_node.name = "return"
	return_method_b_node.attributes.set("type", "bool")
	method_b_node.children.append(return_method_b_node)
	
	methods_node.children.append(method_a_node)
	methods_node.children.append(method_b_node)
	
	class_node.children.append(methods_node)
	
	doc.root = class_node
	
	var db := ClassDocDB.new()
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = builder.build(db)
	
	assert_str(result).is_equal(expected)
