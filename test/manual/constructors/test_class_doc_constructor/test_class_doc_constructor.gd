
extends Node

class Builder extends DocBuilder:
	
	func build(db: ClassDocDB) -> String:
		return db.current_class
	

var parser := DocParser.new("res://test/docs/xml")

var constructor: DocConstructor

func _ready() -> void:
	constructor = ClassDocConstructor.new("res://test/docs/rst", "rst")
	constructor._builders.append(Builder.new())
	
	parser.parse()
	
	prints("result:", error_string(constructor.construct(parser.db)))
