## The [Godocs] class in an interface for parsing the documentation.
## 
## This class allows users to parse the [code].xml[/code] files in a
## directory (recursively, or not), and construct output files using
## an implementation of a [DocConstructor].[br]
## By default, this class will try to use the [RSTDocConstructor], which
## generates, documentation in the [code].rst[/code] format.
class_name Godocs
extends RefCounted

var Constructor: Script

var parser: DocParser

var constructor: DocConstructor

enum ConstructorType {
	
	RST
	
}

func _parse_constructor(constructor: Variant) -> Script:
	if constructor is String:
		return load(constructor) as Script
	if constructor is not ConstructorType:
		return null
	
	match(constructor):
		ConstructorType.RST: return load("uid://lljxfco1posy") as Script
	
	return null

## The [method _init] method defines the constructor for this class.[br]
## The obligatory parameters expected by it are the [param source_path]
## and [param build_path], which define, respectively, the paths from
## where the [code].xml[/code] documentation should be parsed and to
## where the generated output should be stored.[br]
## Additional parameters are also available:[br]
## - The [param constructor_type] stores, by default, [code]"rst"[/code],
## which is the folder where the constructors desired are stored, relative
## to the [param constructors_path] directory.[br]
## - The [param constructors_path], by default
## [code]"res://addons/godocs/constructors/"[/code],
## stores the path to the directory where the [code]constructor[/code] folders
## are stored. Usually, this doesn't need to be changed, unless you want to
## provide your own [DocConstructor]s for this plugin to use.
## TODO
func _init(
	source_path: String,
	build_path: String,
	constructor: Variant = ConstructorType.RST
) -> void:
	self.Constructor = _parse_constructor(constructor)
	
	self.parser = DocParser.new(source_path)
	self.constructor = Constructor.new(build_path)

## The [method execute] method is the entry point for this class to
## realize its task.[br]
## When this method is called, this class parses the [code].xml[/code]
## documentation found on the [param source_path] passed on creation
## and constructs the documentation output to the [param build_path],
## also passed on creation.
func execute() -> Error:
	var error: Error = parser.parse()
	
	if error != OK:
		return error
	
	error = constructor.construct(parser.db)
	
	return error
