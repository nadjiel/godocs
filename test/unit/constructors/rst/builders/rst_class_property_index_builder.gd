
extends GdUnitTestSuite

var builder: DocBuilder = RSTClassPropertyIndexBuilder.new()

var expected: String = '
Property index
==============

.. table::
   :widths: auto

   +-------------------------------+---------------------------------------------+----------+
   | :ref:`String <godocs_String>` | :ref:`property_a <godocs_Class_property_a>` | ``""``   |
   +-------------------------------+---------------------------------------------+----------+
   | :ref:`bool <godocs_bool>`     | :ref:`property_b <godocs_Class_property_b>` | ``true`` |
   +-------------------------------+---------------------------------------------+----------+
'

func test_build_creates_expected_string() -> void:
	var doc := XMLDocument.new()
	
	var class_node := XMLNode.new()
	class_node.attributes.set("name", "Class")
	
	var members_node := XMLNode.new()
	members_node.name = "members"
	
	var property_a_node := XMLNode.new()
	property_a_node.name = "member"
	property_a_node.attributes.set("name", "property_a")
	property_a_node.attributes.set("type", "String")
	property_a_node.attributes.set("default", '""')
	
	var property_b_node := XMLNode.new()
	property_b_node.name = "member"
	property_b_node.attributes.set("name", "property_b")
	property_b_node.attributes.set("type", "bool")
	property_b_node.attributes.set("default", "true")
	
	members_node.children.append(property_a_node)
	members_node.children.append(property_b_node)
	
	class_node.children.append(members_node)
	
	doc.root = class_node
	
	var db := ClassDocDB.new()
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = builder.build(db)
	
	assert_str(result).is_equal(expected)
