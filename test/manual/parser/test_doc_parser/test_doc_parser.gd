
extends Node

var parser := DocParser.new("res://test/docs/")

func _ready() -> void:
	prints("Result:", error_string(parser.parse()), "\n")
	
	for doc: XMLDocument in parser.db.get_class_document_list():
		print(doc.root.attributes.get("name", "NONAME"))
