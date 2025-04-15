## Transforms a [b]BBCode[/b] [String] into an [b]Abstract Syntax Tree[/b].
## 
## The [BBCodeSyntaxInterpreter] class can translate a text written in
## [b]BBCode[/b] to an abstract representation using [AbstractSyntaxNode]s.[br]
## To do that, this class extends the [SyntaxInterpreter] class and adds
## its own logic to it.[br]
## [i]See also: [SyntaxInterpreter] and [AbstractSyntaxNode][/i]
class_name BBCodeSyntaxInterpreter
extends SyntaxInterpreter

# The [member _el_regex] property stores a [RegEx] that matches [b]BBCode[/b]
# elements, so that this class can detect different kind of elements and
# perform the logic needed according to each one.
var _el_regex := RegEx.create_from_string(
	r"\[(?<name>\w+)(?<options>[\S\s]*?)\](?:(?<content>[\S\s]*?)\[(?<closing>\/)\1\])?"
)

## The [method interpret] method [b]overrides[/b] its parent
## [method SyntaxInterpreter.interpret]
## in order to define how this Interpreter performs the
## [b]parsing[/b] of a text with the [b]BBCode[/b] syntax to an
## [b]Abstract Syntax Tree[/b].[br]
## [i]See also: [AbstractSyntaxNode][/i]
func interpret(text: String) -> AbstractSyntaxTagNode:
	return _parse_text(text)

# The [method _parse_options] method takes an [param options] [String],
# gotten from the options of a [b]BBCode element[/b], and organizes its data
# inside a [Dictionary] for ease of use.[br]
# The received [param options] are expected to have a format similar to:
# [code]" a=b c=d"[/code], as BBCode element options usually are.[br]
# Generally, these options go to an inner [Dictionary]
# (inside a [code]"map"[/code] key) in the
# [code]"{ "a": "b", "c": "d" }"[/code] format.[br]
# In the case of options that only have keys, but not values, they go to
# an [Array] inside a [code]"list"[/code] key.[br]
# In resume, if a [String] like this is provided: [code]"=a b=c d=e"[/code],
# The return will be something like this:
# [codeblock lang=gdscript]
# {
#   "list": [ "a" ],
#   "map": {
#     "b": "c",
#     "d": "e",
#   }
# }
# [/codeblock]
func _parse_options(options: String) -> Dictionary:
	var result: Dictionary[String, Variant] = {
		"list": [] as Array[String],
		"map": {} as Dictionary[String, String]
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

# The [method _parse_reference_tag] method takes a [RegExMatch] and interprets
# it, transforming in an [AbstractSyntaxTagNode].[br]
# The [param el_match] received must be a [RegExMatch] got from a match
# of the [member el_regex] property, so that the expected [String]s are
# available.[br]
# To realize this parsing, this method uses information available at the
# Godot Docs at this
# [url=https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html#bbcode-and-class-reference]link[/url].
# [i]See also: [AbstractSyntaxTagNode][/i]
func _parse_reference_tag(el_match: RegExMatch) -> AbstractSyntaxTagNode:
	var name: String = el_match.get_string("name")
	var options: String = el_match.get_string("options")
	
	var params: Dictionary[String, Variant] = _parse_options(options)
	
	# Converts every possible reference to a "reference" Node.
	match name:
		"annotation",\
		"constant",\
		"enum",\
		"member",\
		"method",\
		"constructor",\
		"operator",\
		"signal",\
		"theme_item":
			return AbstractSyntaxTagNode.new(
				"reference", [], { "type": name, "name": params["list"][0] }
			)
	
	# If the reference is a [param something], converts to inline code.
	if name == "param":
		return AbstractSyntaxTagNode.new(
			"code", [ AbstractSyntaxTextNode.new(params["list"][0]) ]
		)
	
	# If the reference is none of the above, assumes it is a Class reference.
	return AbstractSyntaxTagNode.new("reference", [], {
		"type": "class", "name": name
	})

# The [method _parse_tag] method takes a [RegExMatch] and interprets
# it, transforming it in an [AbstractSyntaxNode].[br]
# This method assumes the [param el_match] received is a standalone element
# (autoclosed, like this: [code][lb]tag[rb][/code])[br]
# Also, that parameter must be a [RegExMatch] got from a match
# of the [member el_regex] property, so that the expected [String]s are
# available, describing details about the tag in question.[br]
# To realize this parsing, this method uses information available at the
# Godot Docs at this
# [url=https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html#bbcode-and-class-reference]link[/url].
# [i]See also: [AbstractSyntaxNode][/i]
func _parse_tag(el_match: RegExMatch) -> AbstractSyntaxNode:
	var name: String = el_match.get_string("name")
	var options: String = el_match.get_string("options")
	
	var params: Dictionary[String, Variant] = _parse_options(options)
	
	match name:
		# Returns a new line tag Node.
		"br": return AbstractSyntaxTagNode.new("newline")
		# Returns a text Node with "[".
		"lb": return AbstractSyntaxTextNode.new("[")
		# Returns a text Node with "]".
		"rb": return AbstractSyntaxTextNode.new("]")
	
	# If the tag isn't any of the above, it's assumed it is a reference tag,
	# (tags that point to a Class, a property etc).
	return _parse_reference_tag(el_match)

# The [method _parse_element] method takes a [RegExMatch] and interprets
# it, transforming it in an [AbstractSyntaxNode].[br]
# The [param el_match] parameter must be a [RegExMatch] got from a match
# of the [member el_regex] property, so that the expected [String]s are
# available, describing details about the element in question.[br]
# To realize this parsing, this method uses information available at the
# Godot Docs at this
# [url=https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html#bbcode-and-class-reference]link[/url].
# [i]See also: [AbstractSyntaxNode][/i]
func _parse_element(el_match: RegExMatch) -> AbstractSyntaxNode:
	# If the match doesn't have a closing tag, it is a standalone tag.
	if el_match.get_string("closing").is_empty():
		return _parse_tag(el_match)
	
	var name: String = el_match.get_string("name")
	var content: String = el_match.get_string("content")
	var options: String = el_match.get_string("options")
	
	var params: Dictionary[String, Variant] = _parse_options(options)
	
	var element := AbstractSyntaxTagNode.new(name)
	
	match name:
		# Converts general markup to standard tag Nodes.
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
		# For the below cases, don't parse the contents, as they aren't meant
		# to be parsed (they are either keyboard keys or code samples).
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
	
	# If there is any content inside the element parsed, use _parse_text to
	# parse it and append it to the element as root.
	# Since _parset_text may use this own method, this can end up
	# being recursive.
	if not content.is_empty():
		element = _parse_text(content, element)
	
	return element

# To realize this parsing, this method uses information available at the
# Godot Docs at this
# [url=https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html#bbcode-and-class-reference]link[/url].
# [i]See also: [AbstractSyntaxNode][/i]

# The [method _parse_text] method takes a [String] and interprets
# it, transforming it in an [b]Abstract Syntax Tree[/b] with an
# [AbstractSyntaxTagNode] as its root.[br]
# Optionally, another [AbstractSyntaxTagNode] can be passed as the [param root]
# of the Abstract Syntax Tree to be returned, which allows this method to be
# used internally in a recursive way by the [method _parse_element] method.[br]
# If not passed another root, the default one has a [code]"root"[/code] name.[br]
# Since [b]BBCode[/b] can have elements inside other elements, this method
# adopts a recursive approach by using the [method _parse_text], which, by
# its turn, uses this method.[br]
# To realize its parsing, this method uses information available at the
# Godot Docs at this
# [url=https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html#bbcode-and-class-reference]link[/url].
# [i]See also: [AbstractSyntaxTagNode][/i]
func _parse_text(
	text: String,
	root := AbstractSyntaxTagNode.new("root")
) -> AbstractSyntaxTagNode:
	var text_start: int = 0
	var text_end: int = text.length()
	
	# Searches all elements with the _el_regex.
	var el_matches: Array[RegExMatch] = _el_regex.search_all(text)
	
	# If no elements are found, the entire content is considered plain text.
	if el_matches.is_empty():
		root.children.append(AbstractSyntaxTextNode.new(text))
		return root
	
	var prev_el_end: int = text_start
	
	# For each element found
	for i: int in el_matches.size():
		var el_match: RegExMatch = el_matches[i]
		
		var el_start: int = el_match.get_start()
		var el_end: int = el_match.get_end()
		
		# Parse the content prior to this element, if any.
		if el_start > prev_el_end:
			root.children.append(AbstractSyntaxTextNode.new(
				text.substr(prev_el_end, el_start - prev_el_end)
			))
		
		# Parse the element found, and, consequentially, its children.
		root.children.append(_parse_element(el_match))
		
		# Parse the remaining contents, if any.
		if i == el_matches.size() - 1:
			if el_end < text_end:
				root.children.append(AbstractSyntaxTextNode.new(
					text.substr(el_end, -1)
				))
		
		prev_el_end = el_end
	
	return root
