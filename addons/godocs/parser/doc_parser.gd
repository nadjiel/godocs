
class_name DocParser
extends RefCounted

var path: String

var recursive: bool

var db: ClassDocDB = ClassDocDB.new()

func _init(
	path: String,
	recursive: bool = true,
) -> void:
	self.path = path
	self.recursive = recursive

func parse() -> Error:
	var error: Error = ERR_DOES_NOT_EXIST
	
	if DirAccess.dir_exists_absolute(path):
		error = _read_directory(path, recursive)
	elif FileAccess.file_exists(path):
		error = _read_file(path)
	
	if error != OK:
		return error
	
	return OK

func _get_file_format(path: String) -> String:
	return path.rsplit(".", true, 1)[-1]

func _read_file(path: String) -> Error:
	if _get_file_format(path) != "xml":
		return ERR_FILE_UNRECOGNIZED
	
	var document: XMLDocument = XML.parse_file(path)
	
	db.set_class_document(document)
	
	return OK

func _read_directory(path: String, recursive: bool = true) -> Error:
	if not DirAccess.dir_exists_absolute(path):
		return ERR_DOES_NOT_EXIST
	
	var files: PackedStringArray = DirAccess.get_files_at(path)
	
	for file: String in files:
		_read_file(path.path_join(file))
	
	if not recursive:
		return OK
	
	var sub_directories: PackedStringArray = DirAccess.get_directories_at(path)
	
	for sub_directory: String in sub_directories:
		_read_directory(path.path_join(sub_directory))
	
	return OK
