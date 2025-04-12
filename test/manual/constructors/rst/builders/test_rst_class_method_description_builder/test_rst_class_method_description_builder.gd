
extends Node

var parser := DocParser.new("res://test/docs/xml/Godocs.xml")

var builder: DocBuilder = RSTClassMethodDescriptionBuilder.new()

func _ready() -> void:
	parser.parse()
	
	parser.db.current_class = "Godocs"
	
	prints("Result:\n", builder.build(parser.db))
