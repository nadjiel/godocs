
class_name RSTDocBuilder
extends DocBuilder

const COMMENT_PREFIX: String = ".. "

static func parse_class_name(name: String) -> String:
	return name.replace(".", "_")

static func make_bold(content: String) -> String:
	var result: String = "**%s**" % content
	
	return result

static func make_comment(content: String) -> String:
	var content_output: String = content
	
	var result: String = COMMENT_PREFIX
	
	if content.contains("\n"):
		var prefix_size: int = COMMENT_PREFIX.length()
		var indent: String = " ".repeat(prefix_size)
		content_output = content_output.indent(indent)
		
		result += "\n"
	
	result += content_output
	
	return result

static func make_label(
	name: String
) -> String:
	var result: String = "%s:" % make_comment("_" + name)
	
	return result

static func make_directive(
	name: String,
	arguments: Array[String] = [],
	options: Dictionary[String, String] = {},
	content: String = ""
) -> String:
	var name_output: String = name
	
	var arguments_output: String = arguments.reduce((
		func(prev: String, next: String) -> String:
			return prev + next + " "
	), "")
	
	var options_output: String = ""
	
	for i: int in options.keys().size():
		var option: String = options.keys()[i]
		var value: String = options[option]
		
		options_output += ":%s: %s" % [
			option, value
		]
		
		if i < options.size() - 1:
			options_output += "\n"
	
	if options_output != "":
		options_output = options_output.indent("   ")
	
	var content_output: String = content.indent("   ")
	
	var result: String = "%s::" % [ make_comment(name_output) ]
	
	if arguments_output != "":
		result += " %s" % arguments_output
	if options_output != "":
		result += "\n%s" % options_output
	if content_output != "":
		result += "\n\n%s" % content_output
	
	return result

static func make_role(
	name: String,
	content: String = "",
	target: String = ""
) -> String:
	var name_output: String = name
	var content_output: String = content
	var target_output: String = target
	
	var result: String = ":%s:" % name_output
	
	if target_output != "":
		target_output = "<%s>" % target_output
	if content_output != "" or target_output != "":
		result = "%s`%s%s`" % [
			result,
			content_output,
			target_output
		]
	
	return result

static func make_ref(content: String, target: String) -> String:
	return make_role("ref", content, target)
