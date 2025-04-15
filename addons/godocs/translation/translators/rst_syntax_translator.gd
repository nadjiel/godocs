# TODO: Move code from RSTDocBuilder to this class.
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
		"bold": return RSTDocBuilder.make_bold(content)
		"newline": return "\n"
		"italics": return RSTDocBuilder.make_italics(content)
		"paragraph": return content
		"code": return RSTDocBuilder.make_code(content)
		"codeblock": return RSTDocBuilder.make_codeblock(
			content, node.params.get("language", "")
		)
		"link": return RSTDocBuilder.make_link(node.params.get("url"), content)
		"reference": return RSTDocBuilder.make_code_member_ref(
			node.params.get("name", "")
		)
	
	return content
