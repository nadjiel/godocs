
class_name BBCodeSyntaxInterpreter
extends SyntaxInterpreter

var el_regex := RegEx.create_from_string(
	r"\[(?<name>\w+)(?<options>[\S\s]*?)\](?:(?<content>[\S\s]*?)\[(?<closing>\/)\1\])?"
)

func parse_options(options: String) -> Dictionary:
	var result: Dictionary[String, Variant] = {
		"list": [],
		"map": {}
	}
	
	var pairs: PackedStringArray = options.split(" ", false)
	
	for pair: String in pairs:
		var key_value: PackedStringArray = pair.split("=")
		
		var key: String = key_value[0]
		
		if key_value.size() == 1:
			result["list"].append(key)
			continue
		
		var value: String = key_value[1]
		
		result["map"][key] = value
	
	return result

func parse_reference_tag(el_match: RegExMatch) -> AbstractSyntaxTagNode:
	var name: String = el_match.get_string("name")
	var options: String = el_match.get_string("options")
	
	var params: Dictionary[String, Variant] = parse_options(options)
	
	match name:
		"annotation", "constant", "enum", "member", "method", "constructor", "operator", "signal", "theme_item":
			return AbstractSyntaxTagNode.new(
				"reference", [], { "type": name, "name": params["list"][0] }
			)
	
	if name == "param":
		return AbstractSyntaxTagNode.new(
			"code", [ AbstractSyntaxTextNode.new(params["list"][0]) ]
		)
	
	return AbstractSyntaxTagNode.new("reference", [], {
		"type": "class", "name": name
	})

func parse_tag(el_match: RegExMatch) -> AbstractSyntaxNode:
	var name: String = el_match.get_string("name")
	var options: String = el_match.get_string("options")
	
	var params: Dictionary[String, Variant] = parse_options(options)
	
	match name:
		"br": return AbstractSyntaxTagNode.new("newline")
		"lb": return AbstractSyntaxTextNode.new("[")
		"rb": return AbstractSyntaxTextNode.new("]")
	
	return parse_reference_tag(el_match)

func parse_element(el_match: RegExMatch) -> AbstractSyntaxNode:
	if el_match.get_string("closing").is_empty():
		return parse_tag(el_match)
	
	var name: String = el_match.get_string("name")
	var content: String = el_match.get_string("content")
	var options: String = el_match.get_string("options")
	
	var params: Dictionary[String, Variant] = parse_options(options)
	
	var element := AbstractSyntaxTagNode.new(name)
	
	match name:
		"p": element.name = "paragraph"
		"b": element.name = "bold"
		"i": element.name = "italics"
		"s": element.name = "strikethrough"
		"u": element.name = "underline"
		"center":
			element.name = "alignment"
			element.params["orientation"] = "horizontal"
			element.params["direction"] = "center"
		"color":
			element.name = "color"
			element.params["value"] = params["map"].get("", "")
		"font":
			element.name = "font"
			element.params["path"] = params["map"].get("", "")
		"img":
			element.name = "image"
			element.params["width"] = params["map"].get("width")
		"url":
			element.name = "link"
			element.params["url"] = params["map"].get("", content)
		"kbd":
			element.name = "keyboard"
			element.children.append(AbstractSyntaxTextNode.new(content))
			return element
		"code":
			element.name = "code"
			element.children.append(AbstractSyntaxTextNode.new(content))
			return element
		"codeblock":
			element.name = "codeblock"
			element.params["language"] = params["map"].get("lang", "")
			element.children.append(AbstractSyntaxTextNode.new(content))
			return element
	
	if not content.is_empty():
		element = parse_text(content, element)
	
	return element

func parse_text(
	text: String,
	root := AbstractSyntaxTagNode.new("root")
) -> AbstractSyntaxTagNode:
	var text_start: int = 0
	var text_end: int = text.length()
	
	var el_matches: Array[RegExMatch] = el_regex.search_all(text)
	
	if el_matches.is_empty():
		root.children.append(AbstractSyntaxTextNode.new(text))
		return root
	
	var prev_el_end: int = text_start
	
	for i: int in el_matches.size():
		var el_match: RegExMatch = el_matches[i]
		
		var el_start: int = el_match.get_start()
		var el_end: int = el_match.get_end()
		
		if el_start > prev_el_end:
			root.children.append(AbstractSyntaxTextNode.new(
				text.substr(prev_el_end, el_start - prev_el_end)
			))
		
		root.children.append(parse_element(el_match))
		
		if i == el_matches.size() - 1:
			if el_end < text_end:
				root.children.append(AbstractSyntaxTextNode.new(
					text.substr(el_end, -1)
				))
		
		prev_el_end = el_end
	
	return root

func interpret(text: String) -> AbstractSyntaxTagNode:
	return parse_text(text)
