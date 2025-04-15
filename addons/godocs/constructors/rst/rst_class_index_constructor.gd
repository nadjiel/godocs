
class_name RSTClassIndexConstructor
extends DocConstructor

func _init(
	build_path: String
) -> void:
	super._init(build_path, "rst")
	
	self._doc_name = "index"
	self._builders = [
		RSTClassIndexBuilder.new()
	]
