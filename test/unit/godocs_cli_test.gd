
extends GdUnitTestSuite

var godocs: GodocsCLI

func test_godocs_parses_key_value_arguments() -> void:
	godocs = GodocsCLI.new()
	godocs._parse_args([
		"src=src_path",
		"build=build_path",
	])
	
	var args: Dictionary = godocs._args
	
	assert_dict(args)\
		.contains_key_value("src", "src_path")\
		.contains_key_value("build", "build_path")
	
	godocs.free()

func test_godocs_parses_constructor_type_to_enum() -> void:
	godocs = GodocsCLI.new()
	
	var result := godocs._parse_constructor_type("RST") as Godocs.ConstructorType
	
	assert_that(result)\
		.is_equal(Godocs.ConstructorType.RST)
	
	godocs.free()

func test_godocs_parses_constructor_type_to_path() -> void:
	godocs = GodocsCLI.new()
	
	var expected: String = "addons/godocs/constructors/rst/rst_doc_constructor.gd"
	
	var result := godocs._parse_constructor_type(expected) as String
	
	assert_that(result)\
		.is_equal(expected)
	
	godocs.free()
