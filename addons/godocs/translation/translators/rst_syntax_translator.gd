
class_name RSTSyntaxTranslator
extends SyntaxTranslator

func translate_text(node: AbstractSyntaxTextNode) -> String:
	return node.content

func translate_tag(node: AbstractSyntaxTagNode) -> String:
	var content: String = node.children.reduce((
		func(prev: String, next: AbstractSyntaxNode) -> String:
			return prev + next.translate(self)
	), "")
	
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
