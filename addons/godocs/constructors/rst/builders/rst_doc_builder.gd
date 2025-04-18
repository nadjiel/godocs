## Provides utilities to use when creating RST documentation.
## 
## The [RSTDocBuilder] class can be [b]extended[/b] in order for its subclasses
## to have better access to the utilities it provides.[br]
## In this class are concentrated methods that help with the [b]creation of
## repetitive parts[/b] of the documentation, like [b]property and method
## signatures[/b].[br]
## This class also provides an utility method that helps autocompleting
## references to class members (properties, methods etc) based on the
## context provided by a [ClassDocDB]. This is useful when parsing arbitrary
## documentation texts written by users, which may contain references
## without complete paths.[br]
## See this class' methods in order to have a better understanding of what they
## do exactly.
class_name RSTDocBuilder
extends DocBuilder

## The [method autocomplete_code_member_refs] method can be used to transform
## incomplete references to class members contained in the [param text] argument
## into complete ones, using the context provided by the [param db] argument.
## [br]
## This is useful when parsing arbitrary documentation written by users,
## which may contain references without complete paths.[br]
## As an example, supposing we have a [ClassDocDB] with its
## [member ClassDocDB.current_class] pointing to a class with name
## [code]"ClassName"[/code], calling this method would provoke the following
## results:
## [codeblock lang=rst]
## .. Input
## "Reference to :ref:`method <godocs_method>`"
## .. Output
## "Reference to :ref:`method <godocs_ClassName_method>`"
## [/codeblock]
## Note that, in order to know if a [code]ref[/code] was created by this
## plugin and should be parsed, this method only handles the ones that have
## their target starting with the prefix defined in the
## [member RSTSyntaxTranslator.godocs_ref_prefix], which, by default
## is [code]"godocs"[/code].
static func autocomplete_code_member_refs(
	text: String,
	db: ClassDocDB,
) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	
	if doc == null:
		return text
	
	var doc_name: String = doc.root.attributes.get("name", "")
	
	# Puts all code member names listed by the return of
	# ClassDocDB.get_class_member_dict in a single Array
	var class_members_by_type := db.get_class_member_dict()
	var class_member_lists: Array[Array] = []
	class_member_lists.assign(class_members_by_type.values())
	var code_member_list: Array[String] = []
	for class_member_list: Array[String] in class_member_lists:
		code_member_list.append_array(class_member_list)
	
	var reg: RegEx = _get_code_member_ref_regex()
	
	var prev_start: int = 0
	var start: int = 0
	var offset: int = 0
	
	# Searches for ref matches until none is found
	while true:
		var ref_match: RegExMatch = reg.search(text, start)
		
		# If no ref match is found cancel search
		if ref_match == null:
			break
		
		var old_ref: String = ref_match.get_string()
		var target_name: String = ref_match.get_string("target")
		var full_target_name: String = ".".join([ doc_name, target_name ])
		var new_ref: String = RSTSyntaxTranslator.make_code_member_ref(
			full_target_name,
			target_name,
		)
		
		# Keeps track of how much the String length changes with each
		# replacement
		offset += new_ref.length() - old_ref.length()
		
		# Keeps track of the start of the previous match and the new one
		prev_start = start
		start = ref_match.get_end() + offset
		
		# Substitute the found ref only if it is pointing to
		# one of the members of the current class from the db
		if ref_match.get_string("target") in code_member_list:
			text = reg.sub(text, new_ref, false, prev_start)
	
	return text

## The [method make_property_signature] method helps with the creation
## of a RST text describing the signature of a property.[br]
## The [param full_name] of the property to be described must be passed
## (including the path that leads to it, like so:
## [code]"Class.InnerClass.property"[/code]).[br]
## Optionally, the [param type] stored by this property as well as its
## [param default_value] can also be passed.[br]
## Finally, a [code]bool[/code] [param make_ref] can be passed to tell
## if the name of the property should be created as a reference to its
## path, or just a plain text name.[br]
## The output of this method looks like follows:
## [codeblock lang=rst]
## String :ref:`property <Class_property>` = ``""``
## 
## .. Or, with make_ref set to false
## 
## String property = ``""``
## [/codeblock]
## Note that any [code]refs[/code] created follow the [code]ref[/code]
## creation rules from the [RSTSyntaxTranslator] class.
static func make_property_signature(
	full_name: String,
	type: String = "",
	default_value: String = "",
	is_static: bool = false,
	make_ref: bool = true,
) -> String:
	var result: String = ""
	
	if is_static:
		result += "static "
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

## The [method make_method_signature] method helps with the creation
## of a RST text describing the signature of a method.[br]
## The [param full_name] of the method to be described must be passed
## (including the path that leads to it, like so:
## [code]"Class.InnerClass.method"[/code]).[br]
## Optionally, the [param type] returned by this method as well as its
## [param params] can also be passed.[br]
## The [param params] should follow the following format:
## [codeblock lang=gdscript]
## {
##   "name": <String>, # The name of the param
##   "type": <String>, # The type of the param
##   "default": <String>, # The default value of the param
## }
## [/codeblock]
## Finally, a [code]bool[/code] [param make_ref] can be passed to tell
## if the name of the method should be created as a reference to its
## path, or just a plain text name.[br]
## The output of this method looks like follows:
## [codeblock lang=rst]
## String :ref:`method <Class_method>`\(int a = ``1``, int b = ``2``\)
## 
## .. Or, with make_ref set to false
## 
## String method\(int a = ``1``, int b = ``2``\)
## [/codeblock]
## Note that any [code]refs[/code] created follow the [code]ref[/code]
## creation rules from the [RSTSyntaxTranslator] class.
static func make_method_signature(
	full_name: String,
	return_type: String = "",
	params: Array[Dictionary] = [],
	is_static: bool = false,
	make_ref: bool = true,
) -> String:
	var result: String = ""
	
	if is_static:
		result += "static "
	if not return_type.is_empty():
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
			false,
			false,
		)
		
		if i < params.size() - 1:
			params_output += ", "
	
	params_output += "\\)"
	
	result += params_output
	
	return result

static func make_member_descriptions(
	member_type: String,
	description_maker: Callable,
	db: ClassDocDB,
) -> String:
	var doc: XMLDocument = db.get_current_class_document()
	var node_group: XMLNode = doc.root.get_child_by_name(member_type)
	
	if node_group == null:
		return ""
	
	var result: String = ""
	
	for node: XMLNode in node_group.children:
		var description_output: String = description_maker.call(node, db)
		
		if description_output.is_empty():
			continue
		
		result += description_output
	
	return result

# The method [method _get_code_member_ref_regex] is used to get a [RegEx]
# able to find [code]refs[/code] created by this plugin based
# on the prefix declared in the
# [member RSTSyntaxTranslator.godocs_ref_prefix] property.
static func _get_code_member_ref_regex() -> RegEx:
	var prefix: String = RSTSyntaxTranslator._make_code_member_label_target("")
	
	var string: String = r":ref:`(?:[\S\s]*?)<{prefix}(?<target>[\S\s]*?)>`"\
		.format({ "prefix": prefix })
	
	return RegEx.create_from_string(string)
