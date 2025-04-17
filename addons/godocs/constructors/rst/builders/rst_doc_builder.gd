
class_name RSTDocBuilder
extends DocBuilder

static func autocomplete_code_member_refs(text: String, db: ClassDocDB) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	
	if doc == null:
		return text
	
	var doc_name: String = doc.root.attributes.get("name", "")
	
	var reducer: Callable = func(
		prev: Array[String],
		next: Array[String]
	) -> Array[String]:
		prev.append_array(next)
		
		return prev
	
	var code_member_list: Array[String] = []
	code_member_list.assign(
		db.get_class_member_dict()\
			.values()\
			.reduce(reducer, [])
	)
	
	var reg: RegEx = _get_code_member_ref_regex()
	
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
		var new_ref: String = RSTSyntaxTranslator.make_code_member_ref(full_target_name, target_name)
		
		offset += new_ref.length() - old_ref.length()
		
		prev_start = start
		start = ref_match.get_end() + offset
		
		if ref_match.get_string("target") in code_member_list:
			text = reg.sub(text, new_ref, false, prev_start)
			
			break
	
	return text

static func make_property_signature(
	full_name: String,
	type: String = "",
	default_value: String = "",
	make_ref: bool = true,
) -> String:
	var result: String = ""
	
	if type != "":
		result += RSTSyntaxTranslator.make_code_member_type_ref(type) + " "
	
	var name_parts: PackedStringArray = full_name.rsplit(".", false, 1)
	
	var name: String = name_parts[1] if name_parts.size() > 1 else full_name
	
	if make_ref:
		result += RSTSyntaxTranslator.make_code_member_ref(full_name, name)
	else:
		result += name
	
	if default_value != "":
		result += " = " + RSTSyntaxTranslator.make_code(default_value)
	
	return result

static func make_method_signature(
	full_name: String,
	return_type: String = "",
	params: Array[Dictionary] = [],
	make_ref: bool = true,
) -> String:
	var result: String = ""
	
	if return_type != "":
		result += RSTSyntaxTranslator.make_code_member_type_ref(return_type) + " "
	
	var name_parts: PackedStringArray = full_name.rsplit(".", false, 1)
	
	var name: String = name_parts[1] if name_parts.size() > 1 else full_name
	
	if make_ref:
		result += RSTSyntaxTranslator.make_code_member_ref(full_name, name)
	else:
		result += name
	
	var params_output: String = "\\("
	
	for i: int in params.size():
		var param: Dictionary[String, String] = {}
		param.assign(params[i])
		
		params_output += make_property_signature(
			param.get("name", ""),
			param.get("type", ""),
			param.get("default", ""),
			false
		)
		
		if i < params.size() - 1:
			params_output += ", "
	
	params_output += "\\)"
	
	result += params_output
	
	return result

static func _get_code_member_ref_regex() -> RegEx:
	var prefix: String = RSTSyntaxTranslator._make_code_member_label_target("")
	
	var string: String = r":ref:`(?:[\S\s]*?)<{prefix}(?<target>[\S\s]*?)>`"\
		.format({ "target": prefix })
	
	return RegEx.create_from_string(string)
