
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

var godot_path: String = OS.get_executable_path()

const DOCS_PATH: String = "test/docs"
var src_path: String = DOCS_PATH.path_join("src")
var build_path: String = DOCS_PATH.path_join("build")

func _remove_dir_recursive(path: String) -> Error:
	var files: PackedStringArray = DirAccess.get_files_at(path)
	var subdirs: PackedStringArray = DirAccess.get_directories_at(path)
	
	for file: String in files:
		DirAccess.remove_absolute(path.path_join(file))
	for dir: String in subdirs:
		_remove_dir_recursive(path.path_join(dir))
	
	return DirAccess.remove_absolute(path)

func before() -> void:
	if not DirAccess.dir_exists_absolute(src_path):
		DirAccess.make_dir_recursive_absolute(src_path)
		
		OS.execute(godot_path, [
			"--headless",
			"--doctool",
			"test/docs/src/",
			"--gdscript-docs",
			"res://addons/godocs/"
		])
	if not DirAccess.dir_exists_absolute(build_path):
		DirAccess.make_dir_recursive_absolute(build_path)

func test_godocs_parses_and_builds_docs() -> void:
	var godocs = Godocs.new(
		src_path,
		build_path,
		Godocs.ConstructorType.RST
	)
	
	godocs.execute()
	
	var input_size: int = DirAccess.get_files_at(src_path).size()
	var output_size: int = DirAccess.get_files_at(build_path).size()
	
	assert_int(output_size).is_between(1, input_size + 1)

func after() -> void:
	if DirAccess.dir_exists_absolute(DOCS_PATH):
		_remove_dir_recursive(DOCS_PATH)
