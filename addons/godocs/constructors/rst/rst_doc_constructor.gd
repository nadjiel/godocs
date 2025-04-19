## The [RSTDocConstructor] class creates a set of documents describing a
## whole code base.
## 
## With this class, [b]Restructured Text[/b] (RST) documentation can be
## generated and saved for [b]multiple classes[/b] in a code base.[br]
## In order to do that, this class first needs to be created with a
## [param build_path] where it can later save its output.[br]
## The documentation created by this class includes one [b]file for each known
## class[/b] and one [code]index.rst[/code] file, which list all the other ones
## in a single place.
class_name RSTDocConstructor
extends DocConstructor

var _class_doc_constructor: DocConstructor

var _class_index_constructor: DocConstructor

func _init(build_path: String) -> void:
	_class_doc_constructor = RSTClassDocConstructor.new(build_path)
	_class_index_constructor = RSTClassIndexConstructor.new(build_path)

## The [method construct] method realizes the process of creating the
## RST documetation from all classes described in the [param db] parameter.[br]
## The documentation created includes one [b]file for each class[/b] and one
## [code]index.rst[/code] file listing all the other ones in a single place.[br]
## If an error occurs while doing its task, this method cancels its execution.
## [br]
## If the error does not occur at the start of the generation,
## some documentation may have already been created.[br]
## [i]See also: [ClassDocDB][/i]
func construct(db: ClassDocDB) -> Error:
	var error: Error = _class_doc_constructor.construct(db)
	
	if error != OK:
		return error
	
	error = _class_index_constructor.construct(db)
	
	return error
