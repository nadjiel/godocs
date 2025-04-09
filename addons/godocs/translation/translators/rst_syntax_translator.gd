
class_name RSTSyntaxTranslator
extends SyntaxTranslator

#static func make_reference_label_target(
	#name: String, type: String
#) -> String:
	#if type == "class":
		#return make_class_label_target(name)
	#
	#var name_parts: PackedStringArray = name.rsplit(".", false, 1)
	#
	#var owner_name: String = name_parts[0]
	#var member_name: String = name_parts[1]
	#
	#return make_class_label_target(owner_name) + "_{type}_{name}".format({
		#"type": type,
		#"name": member_name
	#})
#
#static func make_reference(name: String, type: String) -> String:
	#if type == "class":
		#return make_class_reference(name)
	#
	#var name_parts: PackedStringArray = name.rsplit(".", false, 1)
	#
	#var owner_name: String = name_parts[0]
	#var member_name: String = name_parts[1]
	#
	#return make_ref(member_name, make_reference_label_target(name, type))

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
		"codeblock": return RSTDocBuilder.make_codeblock(content, node.params.get("language"))
		"link": return RSTDocBuilder.make_link(node.params.get("url"), content)
		"reference": return node.params.get("name", "")
			#return make_reference(
				#node.params.get("name", ""), node.params.get("type", "")
			#)
	
	return content
