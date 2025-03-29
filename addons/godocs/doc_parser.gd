
class_name DocParser
extends RefCounted

var src_path: String

var recursive: bool

var _db: ClassDocDB = ClassDocDB.new()

func _init(
	src_path: String,
	recursive: bool = true,
) -> void:
	self.src_path = src_path
	self.recursive = recursive

func parse() -> Error:
	var error: Error = OK
	
	if DirAccess.dir_exists_absolute(src_path):
		error = read_directory(src_path, recursive)
	elif FileAccess.file_exists(src_path):
		error = read_file(src_path)
	
	if error != OK:
		return error
	
	return OK

func read_file(path: String) -> Error:
	if not FileAccess.file_exists(path):
		return ERR_FILE_NOT_FOUND
	
	var document: XMLDocument = XML.parse_file(path)
	
	_db.set_class_document(document)
	
	return OK

func read_directory(path: String, recursive: bool = true) -> Error:
	if not DirAccess.dir_exists_absolute(path):
		return ERR_FILE_NOT_FOUND
	
	var files: PackedStringArray = DirAccess.get_files_at(path)
	
	for file: String in files:
		var error: Error = read_file(path.path_join(file))
		
		if error != OK:
			return error
	
	var sub_directories: PackedStringArray = DirAccess.get_directories_at(path)
	
	for sub_directory: String in sub_directories:
		var error: Error = read_directory(path.path_join(sub_directory))
		
		if error != OK:
			return error
	
	return OK
