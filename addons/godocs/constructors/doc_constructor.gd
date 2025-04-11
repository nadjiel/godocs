
class_name DocConstructor
extends RefCounted

var build_path: String

var build_format: String

var _builders: Array[DocBuilder] = []

var _doc_name: String = ""

func _init(
	build_path: String,
	build_format: String = "txt"
) -> void:
	self.build_path = build_path
	self.build_format = build_format

func construct(db: ClassDocDB) -> Error:
	var output: String = DocBuilder.build_all(_builders, db)
	
	return write_to_file(_get_doc_path(), output)

func write_to_file(path: String, content: String) -> Error:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	
	if file == null:
		return ERR_FILE_CANT_WRITE
	
	file.store_string(content)
	
	file.close()
	
	return OK

func _get_doc_path() -> String:
	if _doc_name.is_empty():
		return ""
	
	var result: String = build_path.path_join(_doc_name)
	
	if not build_format.is_empty():
		result += "." + build_format
	
	return result
