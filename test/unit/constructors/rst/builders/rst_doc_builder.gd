
extends GdUnitTestSuite

func test_autocomplete_code_member_refs_works_with_empty_prefixes() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = ""
	
	var text: String = ":ref:`do_something <do_something>` :ref:`store_something <store_something>`"
	
	var db := ClassDocDB.new()
	
	var doc := XMLDocument.new()
	doc.root = XMLNode.new()
	doc.root.name = "class"
	doc.root.attributes.set("name", "Class")
	
	var member := XMLNode.new()
	member.name = "member"
	member.attributes.set("name", "store_something")
	
	var members := XMLNode.new()
	members.name = "members"
	members.children.append(member)
	
	var method := XMLNode.new()
	method.name = "method"
	method.attributes.set("name", "do_something")
	
	var methods := XMLNode.new()
	methods.name = "methods"
	methods.children.append(method)
	
	doc.root.children.append(members)
	doc.root.children.append(methods)
	
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = RSTDocBuilder.autocomplete_code_member_refs(text, db)
	
	assert_str(result).is_equal(":ref:`do_something <Class_do_something>` :ref:`store_something <Class_store_something>`")

func test_autocomplete_code_member_refs_works_with_default_prefix() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = "godocs"
	
	var text: String = ":ref:`do_something <godocs_do_something>` :ref:`store_something <godocs_store_something>`"
	
	var db := ClassDocDB.new()
	
	var doc := XMLDocument.new()
	doc.root = XMLNode.new()
	doc.root.name = "class"
	doc.root.attributes.set("name", "Class")
	
	var member := XMLNode.new()
	member.name = "member"
	member.attributes.set("name", "store_something")
	
	var members := XMLNode.new()
	members.name = "members"
	members.children.append(member)
	
	var method := XMLNode.new()
	method.name = "method"
	method.attributes.set("name", "do_something")
	
	var methods := XMLNode.new()
	methods.name = "methods"
	methods.children.append(method)
	
	doc.root.children.append(members)
	doc.root.children.append(methods)
	
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = RSTDocBuilder.autocomplete_code_member_refs(text, db)
	
	assert_str(result).is_equal(":ref:`do_something <godocs_Class_do_something>` :ref:`store_something <godocs_Class_store_something>`")

func test_autocomplete_code_member_refs_ignores_unknown_refs() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = ""
	
	var text: String = ":ref:`do_something <do_something>` :ref:`store_something <store_something>`"
	
	var db := ClassDocDB.new()
	
	var doc := XMLDocument.new()
	doc.root = XMLNode.new()
	doc.root.name = "class"
	doc.root.attributes.set("name", "Class")
	
	var method := XMLNode.new()
	method.name = "method"
	method.attributes.set("name", "do_something")
	
	var methods := XMLNode.new()
	methods.name = "methods"
	methods.children.append(method)
	
	doc.root.children.append(methods)
	
	db.data.append(doc)
	db.current_class = "Class"
	
	var result: String = RSTDocBuilder.autocomplete_code_member_refs(text, db)
	
	assert_str(result).is_equal(":ref:`do_something <Class_do_something>` :ref:`store_something <store_something>`")

func test_make_property_signature_uses_all_data() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = "godocs"
	
	var result: String = RSTDocBuilder.make_property_signature(
		"Class.store_something",
		"String",
		'""'
	)
	
	assert_str(result).is_equal(':ref:`String <godocs_String>` :ref:`store_something <godocs_Class_store_something>` = ``""``')

func test_make_property_signature_can_make_no_ref() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = "godocs"
	
	var result: String = RSTDocBuilder.make_property_signature(
		"Class.store_something",
		"String",
		'""',
		false,
		false,
	)
	
	assert_str(result).is_equal(':ref:`String <godocs_String>` store_something = ``""``')

func test_make_property_signature_works_without_default_value() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = "godocs"
	
	var result: String = RSTDocBuilder.make_property_signature(
		"Class.store_something",
		"String"
	)
	
	assert_str(result).is_equal(':ref:`String <godocs_String>` :ref:`store_something <godocs_Class_store_something>`')

func test_make_property_signature_works_without_type_value() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = "godocs"
	
	var result: String = RSTDocBuilder.make_property_signature(
		"Class.store_something"
	)
	
	assert_str(result).is_equal(':ref:`store_something <godocs_Class_store_something>`')

func test_make_method_signature_uses_all_data() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = "godocs"
	
	var result: String = RSTDocBuilder.make_method_signature(
		"Class.do_something",
		"String",
		[
			{ "name": "a", "type": "int", "default": "0"},
			{ "name": "b", "type": "float", "default": "-1.0"},
		],
	)
	
	assert_str(result).is_equal(':ref:`String <godocs_String>` :ref:`do_something <godocs_Class_do_something>`\\(:ref:`int <godocs_int>` a = ``0``, :ref:`float <godocs_float>` b = ``-1.0``\\)')
	
func test_make_method_signature_can_make_no_ref() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = "godocs"
	
	var result: String = RSTDocBuilder.make_method_signature(
		"Class.do_something",
		"String",
		[
			{ "name": "a", "type": "int", "default": "0"},
			{ "name": "b", "type": "float", "default": "-1.0"},
		],
		false,
		false,
	)
	
	assert_str(result).is_equal(':ref:`String <godocs_String>` do_something\\(:ref:`int <godocs_int>` a = ``0``, :ref:`float <godocs_float>` b = ``-1.0``\\)')

func test_make_method_signature_works_without_args_value() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = "godocs"
	
	var result: String = RSTDocBuilder.make_method_signature(
		"Class.do_something",
		"String",
	)
	
	assert_str(result).is_equal(':ref:`String <godocs_String>` :ref:`do_something <godocs_Class_do_something>`\\(\\)')

func test_make_method_signature_works_without_type_value() -> void:
	RSTSyntaxTranslator.godocs_ref_prefix = "godocs"
	
	var result: String = RSTDocBuilder.make_method_signature(
		"Class.do_something",
	)
	
	assert_str(result).is_equal(':ref:`do_something <godocs_Class_do_something>`\\(\\)')
