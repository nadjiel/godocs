
class_name RSTDocBuilder
extends DocBuilder

#region General RST

const COMMENT_PREFIX: String = ".. "

static func make_table_row_separator(
	col_widths: Array[int],
	h_sep: String = "-",
	joint: String = "+"
) -> String:
	var result := joint
	
	for width: int in col_widths:
		result += "-".repeat(width) + "+"
	
	return result

static func make_table_row(
	row: Array[String],
	col_widths: Array[int],
	v_sep: String = "|"
) -> String:
	var num_cols: int = col_widths.size()
	
	var result := v_sep
	
	for col_i: int in num_cols:
		var cel: String = row[col_i]
		var col_width: int = col_widths[col_i]
		var padding := " ".repeat(col_width - 2 - cel.length())
		
		result += " " + cel + padding + " " + v_sep
	
	return result

static func make_table_content(
	matrix: Array[Array],
	h_sep: String = "-",
	v_sep: String = "|",
	joint: String = "+"
) -> String:
	if matrix.is_empty():
		return ""
	
	var col_widths: Array[int] = []
	var num_cols: int = matrix[0].size()
	
	# Determine the maximum width for each column
	for col_i: int in num_cols:
		var max_width := 0
		
		for row: Array[String] in matrix:
			var cel: String = row[col_i]
			
			max_width = max(max_width, cel.length() + 2)
		
		col_widths.append(max_width)
	
	var result: String = make_table_row_separator(col_widths, h_sep, joint) + "\n"
	
	for row_i: int in matrix.size():
		var row: Array[String] = []
		row.assign(matrix[row_i])
		
		result += make_table_row(row, col_widths, v_sep) + "\n"
		result += make_table_row_separator(col_widths, h_sep, joint) + "\n"
	
	return result

static func make_heading(content: String, level: int) -> String:
	var character: String = ""
	var line = ""
	
	var result: String = ""
	
	if level == 1 or level == 2:
		character = "="
		line = character.repeat(content.length())
		
		if level == 1:
			result += line + "\n"
	
	result += content + "\n"
	
	if level == 3:
		character = "-"
		line = character.repeat(content.length())
	
	result += line + "\n"
	
	return result

static func make_bold(content: String) -> String:
	var result: String = "**%s**" % content
	
	return result

static func make_italics(text: String) -> String:
	var result: String = "*%s*" % text
	
	return result

static func make_code(content: String) -> String:
	return "``%s``" % content

static func make_codeblock(content: String, language: String = "") -> String:
	var content_output: String = content
	
	content_output = make_directive("code-block", [ language ], {}, content)
	
	var result: String = content_output + "\n"
	
	return result

static func make_link(url: String, content: String = "") -> String:
	if content.is_empty():
		content = url
	
	return "`{label} <{url}>`_".format({
		"label": content,
		"url": url
	})

static func make_comment(content: String) -> String:
	var result: String = COMMENT_PREFIX + content
	
	return result

static func make_comment_block(content: String) -> String:
	var prefix_size: int = COMMENT_PREFIX.length()
	var indent: String = " ".repeat(prefix_size)
	
	var content_output: String = content.indent(indent)
	
	var result: String = COMMENT_PREFIX + "\n" + content_output
	
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

static func make_table(
	content_matrix: Array[Array],
	arguments: Array[String] = [],
	options: Dictionary[String, String] = {}
) -> String:
	var content_output: String = make_table_content(content_matrix)
	
	var result: String = make_directive("table", arguments, options, content_output)
	
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
		target_output = " <%s>" % target_output
	if content_output != "" or target_output != "":
		result = "%s`%s%s`" % [
			result,
			content_output,
			target_output
		]
	
	return result

static func make_ref(content: String, target: String) -> String:
	return make_role("ref", content, target)

#endregion

#region Formatting

## Parses a class name from "A.B" to "A_B" so it works in refs and labels.
static func parse_code_member_name(name: String) -> String:
	return name.replace(".", "_")

static func parse_code_member_type(type: String) -> String:
	var result: String = type
	
	# Substitute Array notation from "type[]" to "Array[type]"
	result = (
		RegEx.create_from_string(r"(\S+)\[\]").sub(result, "Array[$1]")
	)
	# Substitute Inner class notation from Class.InnerClass to Class_InnerClass
	result = parse_code_member_name(result)
	
	return result

static func fix_short_code_member_refs(text: String, db: ClassDocDB) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	
	if doc == null or doc.root == null:
		return text
	
	var doc_name: String = doc.root.attributes.get("name", "")
	
	var possible_appearence_lists: Array[Array] = []
	possible_appearence_lists.append(db.get_class_member_list("members"))
	possible_appearence_lists.append(db.get_class_member_list("methods"))
	possible_appearence_lists.append(db.get_class_member_list("signals"))
	possible_appearence_lists.append(db.get_class_member_list("constants"))
	possible_appearence_lists.append(db.get_class_member_list("theme_items"))
	
	var reg := RegEx.create_from_string(r":ref:`(?:[\S\s]*?)<godocs_(?<target>[\S\s]*?)>`")
	
	var prev_start: int = 0
	var start: int = 0
	var offset: int = 0
	
	while true:
		var ref_match: RegExMatch = reg.search(text, start)
		
		if ref_match == null:
			break
		
		var old_ref: String = ref_match.get_string()
		var target_name: String = ref_match.get_string("target")
		var full_target_name: String = ".".join([ doc_name, target_name ])
		var new_ref: String = make_code_member_ref(full_target_name, target_name)
		
		offset += new_ref.length() - old_ref.length()
		
		prev_start = start
		start = ref_match.get_end() + offset
		
		for possible_appearence_list: Array[String] in possible_appearence_lists:
			if ref_match.get_string("target") in possible_appearence_list:
				text = reg.sub(text, new_ref, false, prev_start)
				
				break
	
	return text

static func make_code_member_label_target(name: String) -> String:
	return "godocs_" + parse_code_member_name(name)

static func make_code_member_label(name: String):
	return make_label(make_code_member_label_target(name))

static func make_code_member_ref(full_name: String, name: String = full_name):
	return make_ref(name, make_code_member_label_target(full_name))

static func make_code_member_type_ref(type: String) -> String:
	var result: String = parse_code_member_type(type)
	
	# Substitute class names for ref links
	result = RegEx.create_from_string(r"([\w]+)").sub(
		result,
		make_code_member_ref("$1"),
		true
	)
	
	return result

static func make_property_signature(
	full_name: String,
	type: String = "",
	default_value: String = ""
) -> String:
	var result: String = ""
	
	if type != "":
		result += make_code_member_type_ref(type) + " "
	
	var name_parts: PackedStringArray = full_name.rsplit(".", false, 1)
	
	var name: String = name_parts[1] if name_parts.size() > 1 else full_name
	
	result += make_code_member_ref(full_name, name)
	
	if default_value != "":
		if default_value == "<unknown>":
			default_value = "unknown"
		
		result += " = " + make_code(default_value)
	
	return result

static func make_method_signature(
	full_name: String,
	return_type: String = "",
	params: Array[Dictionary] = []
) -> String:
	var result: String = ""
	
	if return_type != "":
		result += make_code_member_type_ref(return_type) + " "
	
	var name_parts: PackedStringArray = full_name.rsplit(".", false, 1)
	
	var name: String = name_parts[1] if name_parts.size() > 1 else full_name
	
	result += make_code_member_ref(full_name, name)
	
	var params_output: String = "\\("
	
	for i: int in params.size():
		var param: Dictionary[String, String] = {}
		param.assign(params[i])
		
		params_output += make_property_signature(
			param.get("name", ""),
			param.get("type", ""),
			param.get("default", "")
		)
		
		if i < params.size() - 1:
			params_output += ", "
	
	params_output += "\\)"
	
	result += params_output
	
	return result

#endregion
