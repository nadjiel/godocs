
extends GdUnitTestSuite

var builder: DocBuilder = RSTClassConstantDescriptionBuilder.new()

var expected: String = r'
Constant descriptions
=====================


.. _godocs_Class_CONSTANT_A:

CONSTANT_A = ``""``
-------------------

Description of the CONSTANT_A.


.. _godocs_Class_CONSTANT_B:

CONSTANT_B = ``true``
---------------------

Description of the CONSTANT_B.

'

func test_build_creates_expected_string() -> void:
	var doc := XMLDocument.new()
	
	var class_node := XMLNode.new()
	class_node.attributes.set("name", "Class")
	
	var constant_nodes := XMLNode.new()
	constant_nodes.name = "constants"
	
	var constant_a_node := XMLNode.new()
	constant_a_node.name = "constant"
	constant_a_node.attributes.set("name", "CONSTANT_A")
	constant_a_node.attributes.set("value", '""')
	constant_a_node.content = "Description of the CONSTANT_A."
	
	var constant_b_node := XMLNode.new()
	constant_b_node.name = "constant"
	constant_b_node.attributes.set("name", "CONSTANT_B")
	constant_b_node.attributes.set("value", "true")
	constant_b_node.content = "Description of the CONSTANT_B."
	
	constant_nodes.children.append(constant_a_node)
	constant_nodes.children.append(constant_b_node)
	
	class_node.children.append(constant_nodes)
	
	doc.root = class_node
	
	var db := ClassDocDB.new()
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = builder.build(db)
	
	assert_str(result).is_equal(expected)
