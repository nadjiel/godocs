
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func before() -> void:
	TestUtils.setup_docs()

func test_godocs_parses_and_builds_docs() -> void:
	var godocs = Godocs.new(
		TestUtils.src_path,
		TestUtils.build_path,
		Godocs.ConstructorType.RST
	)
	
	godocs.execute()
	
	var input_size: int = DirAccess.get_files_at(TestUtils.src_path).size()
	var output_size: int = DirAccess.get_files_at(TestUtils.build_path).size()
	
	assert_int(output_size).is_between(1, input_size + 1)

func after() -> void:
	TestUtils.teardown_docs()
