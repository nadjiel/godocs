
extends GdUnitTestSuite

var godocs: GodocsCLI

func test_godocs_parses_key_value_arguments() -> void:
	godocs = auto_free(GodocsCLI.new()) as GodocsCLI
	godocs.parse_args([
		"src=src_path",
		"build=build_path",
	])
	
	var args: Dictionary = godocs.args
	
	assert_dict(args)\
		.contains_key_value("src", "src_path")\
		.contains_key_value("build", "build_path")

func test_godocs_parses_constructor_type_to_enum() -> void:
	godocs = auto_free(GodocsCLI.new()) as GodocsCLI
	
	var result: Godocs.ConstructorType = godocs._parse_constructor_type("RST")
	
	assert_that(result)\
		.is_equal(Godocs.ConstructorType.RST)

func test_godocs_parses_constructor_type_to_path() -> void:
	godocs = auto_free(GodocsCLI.new()) as GodocsCLI
	
	var expected: String = "addons/godocs/constructors/rst/rst_doc_constructor.gd"
	
	var result: Godocs.ConstructorType = godocs._parse_constructor_type(expected)
	
	assert_that(result)\
		.is_equal(expected)
