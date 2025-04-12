
extends Node

func _ready() -> void:
	print_rich("[b]BOLD:[/b] ", RSTDocBuilder.make_bold("bold"))
	print_rich("[b]ITALICS:[/b] ", RSTDocBuilder.make_italics("italics"))
	print_rich("[b]CODE:[/b] ", RSTDocBuilder.make_code("code"))
	print_rich("[b]LINK:[/b] ", RSTDocBuilder.make_link("https://github.com/nadjiel/godocs", "Godocs"))
	print_rich("[b]COMMENT:[/b] ", RSTDocBuilder.make_comment("Comment"))
	print_rich("[b]REFERENCE:[/b] ", RSTDocBuilder.make_ref("Reference", "to_this"))
	print_rich("[b]LABEL:[/b] ", RSTDocBuilder.make_label("label"))
	print_rich("[b]CODE_MEMBER:[/b] ", RSTDocBuilder.parse_code_member_name("OuterClass.InnerClass.Enum.CONSTANT"))
	print_rich("[b]CODE_MEMBER_REFERENCE:[/b] ", RSTDocBuilder.make_code_member_ref("OuterClass.InnerClass.Enum.CONSTANT", "CONSTANT"))
	print_rich("[b]CODE_MEMBER_LABEL:[/b] ", RSTDocBuilder.make_code_member_label("OuterClass.InnerClass.Enum.CONSTANT"))
	print_rich("[b]CODE_MEMBER_TYPE:[/b] ", RSTDocBuilder.parse_code_member_type("OuterClass.InnerClass.Enum[]"))
	print_rich("[b]CODE_MEMBER_TYPE_REFERENCE:[/b] ", RSTDocBuilder.make_code_member_type_ref("OuterClass.InnerClass.Enum[]"))
	print_rich("[b]PROPERTY_SIGNATURE:[/b] ", RSTDocBuilder.make_property_signature("property", "Array", "[]"))
	print_rich("[b]METHOD_SIGNATURE:[/b] ", RSTDocBuilder.make_method_signature("method", "Array", [
		{ "name": "param", "type": "int", "default": "0" }
	]))
	print_rich("[b]COMMENT_BLOCK:[/b]\n", RSTDocBuilder.make_comment_block("Long comment"))
	print_rich("[b]CODE_BLOCK:[/b]\n", RSTDocBuilder.make_codeblock('print("Hello, World!")', "GDScript"))
	print_rich("[b]TABLE:[/b]\n", RSTDocBuilder.make_table([ [ "1", "2" ], [ "3", "4" ] ]))
