
extends GdUnitTestSuite

var builder: DocBuilder = RSTClassPropertyDescriptionBuilder.new()

var expected: String = '
Property descriptions
=====================


.. _godocs_Class_property_a:

:ref:`String <godocs_String>` property_a = ``""``
-------------------------------------------------

Description of the property_a.


.. _godocs_Class_property_b:

:ref:`bool <godocs_bool>` property_b = ``true``
-----------------------------------------------

Description of the property_b.

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
	property_a_node.content = "Description of the property_a."
	
	var property_b_node := XMLNode.new()
	property_b_node.name = "member"
	property_b_node.attributes.set("name", "property_b")
	property_b_node.attributes.set("type", "bool")
	property_b_node.attributes.set("default", "true")
	property_b_node.content = "Description of the property_b."
	
	members_node.children.append(property_a_node)
	members_node.children.append(property_b_node)
	
	class_node.children.append(members_node)
	
	doc.root = class_node
	
	var db := ClassDocDB.new()
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = builder.build(db)
	
	assert_str(result).is_equal(expected)
