## The [DocConstructor] class helps creating documentation output.
## 
## This class is responsible for generating an output documentation
## with the help of a [ClassDocDB] instance and a list of
## [DocBuilder] implementations. After creating that documentation,
## this class then saves it into a file.[br]
## To be instantiated, this class needs a [param build_path] and a
## [build_format] (which defaults to [code]"txt"[/code]).
## These are later used to define where to save the generated output.
class_name DocConstructor
extends RefCounted

# The [member _build_path] property stores a path to the directory where this
# class should store its output.
var _build_path: String

# The [member _build_format] property stores the file format that is supposed
# to be used by this class when creating its output.
var _build_format: String

# The [member _doc_name] property stores the name that should be used to
# save the output file created with this class.
var _doc_name: String = ""

# The [member _builders] property stores an [Array] of [DocBuilder]s that
# are used to create the output documentation of this [DocConstructor].[br]
# [i]See also: [DocBuilder][/i]
var _builders: Array[DocBuilder] = []

func _init(
	build_path: String,
	build_format: String = "txt"
) -> void:
	self._build_path = build_path
	self._build_format = build_format

## The [method construct] method is the main method of this class.[br]
## It's through this method that the creation of its output is realized.[br]
## In order to do that, this method needs a [ClassDocDB] instance, that can be
## provided through the [param db] parameter.[br]
## When called, this method then goes over all [DocBuilder]s it has,
## creating an incremental output with the individual output of each one.[br]
## Finally, when it's over, this method writes to the output file described on
## its creation.
func construct(db: ClassDocDB) -> Error:
	var output: String = DocBuilder.build_all(_builders, db)
	
	return _write_to_file(_get_doc_path(), output)

func _write_to_file(path: String, content: String) -> Error:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	
	if file == null:
		return ERR_FILE_CANT_WRITE
	
	file.store_string(content)
	
	file.close()
	
	return OK

func _get_doc_path() -> String:
	if _doc_name.is_empty():
		return ""
	
	var result: String = _build_path.path_join(_doc_name)
	
	if not _build_format.is_empty():
		result += "." + _build_format
	
	return result
