
class_name TestUtils
extends Node

static var godot_path: String = OS.get_executable_path()

const DOCS_PATH: String = "test/docs"
static var src_path: String = DOCS_PATH.path_join("src")
static var build_path: String = DOCS_PATH.path_join("build")

static func _remove_dir_recursive(path: String) -> Error:
	var files: PackedStringArray = DirAccess.get_files_at(path)
	var subdirs: PackedStringArray = DirAccess.get_directories_at(path)
	
	for file: String in files:
		DirAccess.remove_absolute(path.path_join(file))
	for dir: String in subdirs:
		_remove_dir_recursive(path.path_join(dir))
	
	return DirAccess.remove_absolute(path)

static func setup_docs() -> void:
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

static func teardown_docs() -> void:
	if DirAccess.dir_exists_absolute(DOCS_PATH):
		_remove_dir_recursive(DOCS_PATH)
