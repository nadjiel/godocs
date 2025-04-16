
class_name RSTDocBuilder
extends DocBuilder

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
	return RSTSyntaxTranslator.make_label(make_code_member_label_target(name))

static func make_code_member_ref(full_name: String, name: String = full_name):
	return RSTSyntaxTranslator.make_ref(name, make_code_member_label_target(full_name))

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
		
		result += " = " + RSTSyntaxTranslator.make_code(default_value)
	
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
