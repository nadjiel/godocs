
class_name RSTDocConstructor
extends DocConstructor

var class_doc_constructor: DocConstructor

var class_index_constructor: DocConstructor

func _init(build_path: String) -> void:
	class_doc_constructor = RSTClassDocConstructor.new(build_path)
	class_index_constructor = RSTClassIndexConstructor.new(build_path)

func construct(db: ClassDocDB) -> Error:
	var error: Error = class_doc_constructor.construct(db)
	
	if error != OK:
		return error
	
	error = class_index_constructor.construct(db)
	
	return error
