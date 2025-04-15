
class_name RSTClassDocConstructor
extends ClassDocConstructor

func _init(
	build_path: String
) -> void:
	super._init(build_path, "rst")
	
	self._builders = [
		RSTClassHeadingBuilder.new(),
		RSTClassDescriptionBuilder.new(),
		RSTClassPropertyIndexBuilder.new(),
		RSTClassMethodIndexBuilder.new(),
		RSTClassPropertyDescriptionBuilder.new(),
		RSTClassMethodDescriptionBuilder.new(),
	]
