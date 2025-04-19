
extends GdUnitTestSuite

var interpreter: SyntaxInterpreter

func test_el_regex_captures_important_strings() -> void:
	var text: String = "[url=https://github.com/nadjiel/godocs]Godocs[/url]"
	
	interpreter = BBCodeSyntaxInterpreter.new()
	
	var text_match: RegExMatch = interpreter._el_regex.search(text)
	
	assert_str(text_match.get_string()).is_equal(text)
	assert_str(text_match.get_string("name")).is_equal("url")
	assert_str(text_match.get_string("options")).is_equal("=https://github.com/nadjiel/godocs")
	assert_str(text_match.get_string("content")).is_equal("Godocs")
	assert_str(text_match.get_string("closing")).is_equal("/")

func test_parse_options_organizes_key_values() -> void:
	var options: String = "=main_value key=value option"
	
	interpreter = BBCodeSyntaxInterpreter.new()
	
	var result: Dictionary[String, Variant] = interpreter._parse_options(options)
	
	assert_array(result["list"])\
		.contains([ "option" ])
	assert_dict(result["map"])\
		.contains_key_value("", "main_value")\
		.contains_key_value("key", "value")

func test_parse_reference_tag_returns_a_reference_node() -> void:
	interpreter = BBCodeSyntaxInterpreter.new()
	
	var tag: String = "[operator Color.operator *]"
	var tag_match: RegExMatch = interpreter._el_regex.search(tag)
	
	var result: AbstractSyntaxTagNode = interpreter._parse_reference_tag(tag_match)
	
	assert_str(result.name).is_equal("reference")
	assert_dict(result.params)\
		.contains_key_value("type", "operator")\
		.contains_key_value("name", "Color.operator")\
		.contains_key_value("symbol", "*")

func test_parse_tag_returns_a_newline_node() -> void:
	interpreter = BBCodeSyntaxInterpreter.new()
	
	var tag: String = "[br]"
	var tag_match: RegExMatch = interpreter._el_regex.search(tag)
	
	var result: AbstractSyntaxNode = interpreter._parse_tag(tag_match)
	
	assert_str(result.name).is_equal("newline")

func test_parse_tag_detects_a_reference_tag() -> void:
	interpreter = BBCodeSyntaxInterpreter.new()
	
	var tag: String = "[Class]"
	var tag_match: RegExMatch = interpreter._el_regex.search(tag)
	
	var result: AbstractSyntaxNode = interpreter._parse_tag(tag_match)
	
	assert_str(result.name).is_equal("reference")

func test_parse_element_returns_a_link_node() -> void:
	interpreter = BBCodeSyntaxInterpreter.new()
	
	var tag: String = "[url=https://github.com/nadjiel/godocs]Godocs[/url]"
	var tag_match: RegExMatch = interpreter._el_regex.search(tag)
	
	var result: AbstractSyntaxNode = interpreter._parse_element(tag_match)
	
	assert_str(result.name).is_equal("link")
	assert_dict(result.params)\
		.contains_key_value("url", "https://github.com/nadjiel/godocs")
	assert_str(result.children[0].content).is_equal("Godocs")

func test_parse_element_detects_a_tag_node() -> void:
	interpreter = BBCodeSyntaxInterpreter.new()
	
	var tag: String = "[lb]"
	var tag_match: RegExMatch = interpreter._el_regex.search(tag)
	
	var result: AbstractSyntaxNode = interpreter._parse_element(tag_match)
	
	assert_str(result.content).is_equal("[")

func test_interpret_understands_an_arbitrary_bbcode() -> void:
	interpreter = BBCodeSyntaxInterpreter.new()
	
	var text: String = "Hello, [b]World[/b]![br][i]This[/i] is a [url=https://github.com/nadjiel/godocs]Godocs[/url] test!"
	
	var result: AbstractSyntaxTagNode = interpreter.interpret(text)
	
	assert_str(result.name).is_equal("root")
	assert_str(result.children[0].content).is_equal("Hello, ")
	assert_str(result.children[1].name).is_equal("bold")
	assert_str(result.children[2].content).is_equal("!")
	assert_str(result.children[3].name).is_equal("newline")
	assert_str(result.children[4].name).is_equal("italics")
	assert_str(result.children[5].content).is_equal(" is a ")
	assert_str(result.children[6].name).is_equal("link")
	assert_str(result.children[7].content).is_equal(" test!")

func test_interpret_understands_nested_bbcode() -> void:
	interpreter = BBCodeSyntaxInterpreter.new()
	
	var text: String = "[b]Hello, World! [i]This is a [url=https://github.com/nadjiel/godocs]Godocs[/url][/i] test![/b]"
	
	var result: AbstractSyntaxTagNode = interpreter.interpret(text)
	
	assert_str(result\
		.children[0]\
		.children[1]\
		.children[1]\
		.children[0]\
		.content).is_equal("Godocs")
