# GdUnit generated TestSuite
class_name RstClassIndexBuilderTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/godocs/constructors/rst/builders/rst_class_index_builder.gd'

var Builder := RSTClassIndexBuilder

func test__build_class_list_creates_toctree_with_all_documents() -> void:
	var db := ClassDocDB.new()
	var result: String = Builder.new()._build_class_list(db)
	
	assert_str(result)\
		.contains("toctree")\
		.contains(":glob:")\
		.contains(":maxdepth: 1")\
		.contains("*")

func test_build_creates_page_with_title_and_toctree() -> void:
	var db := ClassDocDB.new()
	var result: String = Builder.new().build(db)
	
	assert_str(result)\
		.contains("Class Index")\
		.contains("toctree")
