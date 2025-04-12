
extends Node

var parser := DocParser.new("res://test/docs/xml/GodocsCLI.xml")

func _ready() -> void:
	parser.parse()
	
	parser.db.current_class = "GodocsCLI"
	
	print_rich("[b]CURRENT_CLASS:[/b] ", parser.db.current_class)
	print_rich("[b]INHERITAGE:[/b] ", parser.db.get_class_inheritage())
	print_rich("[b]PROPERTY_LIST:[/b] ", parser.db.get_class_member_list("members"))
	print_rich("[b]METHOD_LIST:[/b] ", parser.db.get_class_member_list("methods"))
	print_rich("[b]SIGNAL_LIST:[/b] ", parser.db.get_class_member_list("signals"))
	print_rich("[b]CONSTANT_LIST:[/b] ", parser.db.get_class_member_list("constants"))
	print_rich("[b]THEME_ITEM_LIST:[/b] ", parser.db.get_class_member_list("theme_items"))
