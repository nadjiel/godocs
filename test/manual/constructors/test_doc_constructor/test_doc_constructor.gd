
extends Node

class Builder extends DocBuilder:
	
	func build(db: ClassDocDB) -> String:
		return str(db)
	

class Constructor extends DocConstructor:
	
	func _init(path: String) -> void:
		super._init(path, "txt")
		
		_doc_name = "test"
		_builders.append(Builder.new())
	

var doc_db := ClassDocDB.new()

var constructor: DocConstructor

func _ready() -> void:
	constructor = Constructor.new("res://test/docs/rst/")
	
	prints("Result:", error_string(constructor.construct(doc_db)))
