## The [RSTClassIndexConstructor] class creates a document listing the
## classes present in a code base.
## 
## With this class, a [b]Restructured Text[/b] (RST) document listing
## [b]multiple classes[/b] in a code base can be generated and saved.[br]
## In order to do that, this class first needs to be created with a
## [param build_path] where it can later save its output.[br]
## The documentat created by this class is called [code]index.rst[/code].[br]
## To create that document, this class uses the [RSTClassIndexBuilder], which
## defines its resultant structure.[br]
## [i]See also [RSTClassIndexBuilder][/i]
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
