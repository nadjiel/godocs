
extends GdUnitTestSuite

var builder: DocBuilder = RSTClassSignalDescriptionBuilder.new()

var expected: String = r'
Signal descriptions
===================


.. _godocs_Class_signal_a:

signal_a\(\)
------------

Description of the signal_a.


.. _godocs_Class_signal_b:

signal_b\(\)
------------

Description of the signal_b.

'

func test_build_creates_expected_string() -> void:
	var doc := XMLDocument.new()
	
	var class_node := XMLNode.new()
	class_node.attributes.set("name", "Class")
	
	var signals_node := XMLNode.new()
	signals_node.name = "signals"
	
	var signal_a_node := XMLNode.new()
	signal_a_node.name = "signal"
	signal_a_node.attributes.set("name", "signal_a")
	var description_signal_a_node := XMLNode.new()
	description_signal_a_node.name = "description"
	description_signal_a_node.content = "Description of the signal_a."
	signal_a_node.children.append(description_signal_a_node)
	
	var signal_b_node := XMLNode.new()
	signal_b_node.name = "signal"
	signal_b_node.attributes.set("name", "signal_b")
	signal_b_node.content = "Description of the signal_b."
	var description_signal_b_node := XMLNode.new()
	description_signal_b_node.name = "description"
	description_signal_b_node.content = "Description of the signal_b."
	signal_b_node.children.append(description_signal_b_node)
	
	signals_node.children.append(signal_a_node)
	signals_node.children.append(signal_b_node)
	
	class_node.children.append(signals_node)
	
	doc.root = class_node
	
	var db := ClassDocDB.new()
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = builder.build(db)
	
	assert_str(result).is_equal(expected)
