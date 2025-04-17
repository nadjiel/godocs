
extends GdUnitTestSuite

var builder: DocBuilder = RSTClassDescriptionBuilder.new()

var expected: String = "
Description
===========

User created description.
"

func test_build_creates_expected_string() -> void:
	var doc := XMLDocument.new()
	
	var class_node := XMLNode.new()
	class_node.attributes.set("name", "Class")
	
	var description_node := XMLNode.new()
	description_node.name = "description"
	description_node.content = "User created description."
	
	class_node.children.append(description_node)
	
	doc.root = class_node
	
	var db := ClassDocDB.new()
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = builder.build(db)
	
	assert_str(result).is_equal(expected)
