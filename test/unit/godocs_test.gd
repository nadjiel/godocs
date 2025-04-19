
extends GdUnitTestSuite
@warning_ignore_start("shadowed_variable")

var godocs: Godocs

func test_godocs_understands_constructor_type_enum() -> void:
	var godocs = Godocs.new(
		TestUtils.src_path,
		TestUtils.build_path,
		Godocs.ConstructorType.RST
	)
	
	assert_object(godocs.constructor)\
		.is_instanceof(RSTDocConstructor)

func test_godocs_understands_constructor_type_string() -> void:
	var godocs = Godocs.new(
		TestUtils.src_path,
		TestUtils.build_path,
		"uid://lljxfco1posy"
	)
	
	assert_object(godocs.constructor)\
		.is_instanceof(RSTDocConstructor)
