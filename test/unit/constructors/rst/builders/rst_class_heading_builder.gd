
extends GdUnitTestSuite

var builder: DocBuilder = RSTClassHeadingBuilder.new()

var expected: String = "
.. _godocs_Class:

=====
Class
=====

**Inherits:** :ref:`SuperClass <godocs_SuperClass>` **<** :ref:`RefCounted <godocs_RefCounted>`

User created brief description.
"

func test_build_creates_expected_string() -> void:
	var doc := XMLDocument.new()
	var superdoc := XMLDocument.new()
	
	var class_node := XMLNode.new()
	class_node.attributes.set("name", "Class")
	class_node.attributes.set("inherits", "SuperClass")
	
	var superclass_node := XMLNode.new()
	superclass_node.attributes.set("name", "SuperClass")
	superclass_node.attributes.set("inherits", "RefCounted")
	
	var brief_description_node := XMLNode.new()
	brief_description_node.name = "brief_description"
	brief_description_node.content = "User created brief description."
	
	class_node.children.append(brief_description_node)
	
	doc.root = class_node
	superdoc.root = superclass_node
	
	var db := ClassDocDB.new()
	db.data.append(doc)
	db.data.append(superdoc)
	db.current_class = "Class"
	
	var result: String = builder.build(db)
	
	assert_str(result).is_equal(expected)
