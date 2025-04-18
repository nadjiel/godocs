## The [RSTClassDocConstructor] class creates a set of documents describing
## classes from a whole code base.
## 
## With this class, [b]Restructured Text[/b] (RST) documentation can be
## generated and saved for [b]multiple classes[/b] in a code base.[br]
## In order to do that, this class first needs to be created with a
## [param build_path] where it can later save its output.[br]
## The documentation created by this class includes one [b]file for each known
## class[/b].[br]
## The structure of the generated documents is defined, respectively, by
## the [RSTClassHeadingBuilder], [RSTClassDescriptionBuilder],
## [RSTClassPropertyIndexBuilder], [RSTClassMethodIndexBuilder],
## [RSTClassPropertyDescriptionBuilder] and [RSTClassMethodDescriptionBuilder]
## builders. See them for details about each part of the structure.
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
		RSTClassSignalIndexBuilder.new(),
		RSTClassConstantDescriptionBuilder.new(),
		RSTClassPropertyDescriptionBuilder.new(),
		RSTClassMethodDescriptionBuilder.new(),
		RSTClassSignalDescriptionBuilder.new(),
	]
