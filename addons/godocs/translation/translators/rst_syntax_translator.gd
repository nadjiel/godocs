# TODO: Add unit tests.
## Transforms an [b]Abstract Syntax Tree[/b] into a
## [b]RestructuredText[/b] [String].
## 
## The [RSTSyntaxTranslator] class can translate an abstract representation
## of [AbstractSyntaxNode]s into a text written in
## [b]Restructured Text[/b] (RST).[br]
## To do that, this class extends the [SyntaxTranslator] class and adds
## its own logic to it.[br]
## [i]See also: [SyntaxTranslator] and [AbstractSyntaxNode][/i]
class_name RSTSyntaxTranslator
extends SyntaxTranslator

const COMMENT_PREFIX: String = ".. "

static var godocs_ref_prefix: String = "godocs"

#region RST Syntax

static func make_comment(content: String) -> String:
	var result: String = COMMENT_PREFIX + content
	
	return result

static func make_comment_block(content: String) -> String:
	var prefix_size: int = COMMENT_PREFIX.length()
	var indent: String = " ".repeat(prefix_size)
	
	var content_output: String = content.indent(indent)
	
	var result: String = COMMENT_PREFIX + "\n" + content_output
	
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
	if level == 4:
		character = "~"
	
	line = character.repeat(content.length())
	
	result += line + "\n"
	
	return result

static func make_bold(content: String) -> String:
	var result: String = "**%s**" % content
	
	return result

static func make_italics(text: String) -> String:
	var result: String = "*%s*" % text
	
	return result

static func make_link(url: String, content: String = "") -> String:
	if content.is_empty():
		content = url
	
	return "`{label} <{url}>`_".format({
		"label": content,
		"url": url
	})

static func make_code(content: String) -> String:
	return "``%s``" % content

static func make_codeblock(content: String, language: String = "") -> String:
	var content_output: String = content
	
	content_output = _make_directive("code-block", [ language ], {}, content)
	
	var result: String = content_output + "\n"
	
	return result

static func make_table(
	content_matrix: Array[Array],
	arguments: Array[String] = [],
	options: Dictionary[String, String] = {}
) -> String:
	var content_output: String = _make_table_content(content_matrix)
	
	var result: String = _make_directive("table", arguments, options, content_output)
	
	return result

static func make_toctree(
	options: Dictionary[String, String] = {},
	content: Array[String] = []
) -> String:
	var content_output: String = "\n".join(content)
	
	var result: String = _make_directive("toctree", [], options, content_output)
	
	return result

static func make_label(
	name: String
) -> String:
	var result: String = "%s:" % make_comment("_" + name)
	
	return result

static func make_ref(content: String, target: String) -> String:
	return _make_role("ref", content, target)

static func _make_table_row_separator(
	col_widths: Array[int],
	h_sep: String = "-",
	joint: String = "+"
) -> String:
	var result := joint
	
	for width: int in col_widths:
		result += h_sep.repeat(width) + joint
	
	return result

static func _make_table_row(
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

static func _make_table_content(
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
	
	var result: String = RSTSyntaxTranslator._make_table_row_separator(col_widths, h_sep, joint) + "\n"
	
	for row_i: int in matrix.size():
		var row: Array[String] = []
		row.assign(matrix[row_i])
		
		result += _make_table_row(row, col_widths, v_sep) + "\n"
		result += RSTSyntaxTranslator._make_table_row_separator(col_widths, h_sep, joint) + "\n"
	
	return result

static func _make_role(
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

static func _make_directive(
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

#endregion

static func make_code_member_label(name: String) -> String:
	return make_label(_make_code_member_label_target(name))

static func make_code_member_ref(
	full_name: String,
	name: String = full_name
) -> String:
	return make_ref(name, _make_code_member_label_target(full_name))

static func make_code_member_type_ref(full_name: String) -> String:
	var result: String = _normalize_code_member(full_name)
	
	# Substitute class names for ref links
	result = RegEx.create_from_string(r"([\w]+)").sub(
		result,
		make_code_member_ref("$1"),
		true
	)
	
	return result

static func _normalize_code_member(member_reference: String) -> String:
	var result: String = member_reference
	
	# Substitute Array notation from "type[]" to "Array[type]"
	result = (
		RegEx.create_from_string(r"(\S+)\[\]").sub(result, "Array[$1]")
	)
	# Substitute dot notation from "A.B" to "A_B" so it works better
	# in refs and labels.
	result = result.replace(".", "_")
	
	return result

static func _make_code_member_label_target(name: String) -> String:
	var result: String = ""
	
	if not godocs_ref_prefix.is_empty():
		result += godocs_ref_prefix + "_"
	
	result += _normalize_code_member(name)
	
	return result

## The [method translate_text] method [b]overrides[/b] its parent
## [method SyntaxTranslator.translate_text]
## in order to define how this Translator performs the
## [b]parsing[/b] of an [AbstractSyntaxTextNode] to a text with
## [b]RST[/b] syntax.[br]
## To realize that parsing, this method just returns the
## [member AbstractSyntaxTextNode.content], as it's only that that
## that kind of Node represents.[br]
## [i]See also: [AbstractSyntaxTextNode][/i]
func translate_text(node: AbstractSyntaxTextNode) -> String:
	return node.content

## The [method translate_tag] method [b]overrides[/b] its parent
## [method SyntaxTranslator.translate_tag]
## in order to define how this Translator performs the
## [b]parsing[/b] of an [AbstractSyntaxTagNode] to a text with
## [b]RST[/b] syntax.[br]
## [i]See also: [AbstractSyntaxTagNode][/i]
func translate_tag(node: AbstractSyntaxTagNode) -> String:
	# First of all, translates the children of the node received.
	var content: String = node.children.reduce((
		func(prev: String, next: AbstractSyntaxNode) -> String:
			return prev + next.translate(self)
	), "")
	
	# Depending on the node name, the resultant syntax will change.
	match node.name:
		"root": return content
		"bold": return make_bold(content)
		"newline": return "\n"
		"italics": return make_italics(content)
		"paragraph": return content
		"code": return make_code(content)
		"codeblock": return make_codeblock(
			content, node.params.get("language", "")
		)
		"link": return make_link(node.params.get("url"), content)
		"reference": return make_code_member_ref(
			node.params.get("name", "")
		)
	
	return content
