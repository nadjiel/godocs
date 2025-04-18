
extends GdUnitTestSuite

var builder: DocBuilder = RSTClassEnumDescriptionBuilder.new()

var expected: String = r'
Enumeration descriptions
========================


.. _godocs_Class_EnumA:

EnumA
-----


.. _godocs_Class_EnumA_CONSTANT_A:

CONSTANT_A = ``0``
~~~~~~~~~~~~~~~~~~

Description of the CONSTANT_A.


.. _godocs_Class_EnumB:

EnumB
-----


.. _godocs_Class_EnumB_CONSTANT_A:

CONSTANT_A = ``0``
~~~~~~~~~~~~~~~~~~

Description of the CONSTANT_A.

'

func test_build_creates_expected_string() -> void:
	var doc := XMLDocument.new()
	
	var class_node := XMLNode.new()
	class_node.attributes.set("name", "Class")
	
	var constant_nodes := XMLNode.new()
	constant_nodes.name = "constants"
	
	var enum_a_constant_a_node := XMLNode.new()
	enum_a_constant_a_node.name = "constant"
	enum_a_constant_a_node.attributes.set("name", "CONSTANT_A")
	enum_a_constant_a_node.attributes.set("value", '0')
	enum_a_constant_a_node.attributes.set("enum", 'EnumA')
	enum_a_constant_a_node.content = "Description of the CONSTANT_A."
	
	var enum_b_constant_a_node := XMLNode.new()
	enum_b_constant_a_node.name = "constant"
	enum_b_constant_a_node.attributes.set("name", "CONSTANT_A")
	enum_b_constant_a_node.attributes.set("value", '0')
	enum_b_constant_a_node.attributes.set("enum", 'EnumB')
	enum_b_constant_a_node.content = "Description of the CONSTANT_A."
	
	constant_nodes.children.append(enum_a_constant_a_node)
	constant_nodes.children.append(enum_b_constant_a_node)
	
	class_node.children.append(constant_nodes)
	
	doc.root = class_node
	
	var db := ClassDocDB.new()
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = builder.build(db)
	
	assert_str(result).is_equal(expected)
