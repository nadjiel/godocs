
extends Node

var parser := DocParser.new("res://test/docs/xml/GodocsCLI.xml")

var builder: DocBuilder = RSTClassHeadingBuilder.new()

func _ready() -> void:
	parser.parse()
	
	parser.db.current_class = "GodocsCLI"
	
	prints("Result:\n", builder.build(parser.db))
