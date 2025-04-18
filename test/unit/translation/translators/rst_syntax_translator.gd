
extends GdUnitTestSuite

func test__make_table_row_separator_makes_one_column() -> void:
	var sep: String = RSTSyntaxTranslator._make_table_row_separator([ 1 ], "-", "+")
	
	assert_str(sep).is_equal("+-+")

func test__make_table_row_separator_makes_multiple_columns() -> void:
	var sep: String = RSTSyntaxTranslator._make_table_row_separator([ 1, 1, 1 ], "-", "+")
	
	assert_str(sep).is_equal("+-+-+-+")

func test__make_table_row_separator_uses_right_widths() -> void:
	var sep: String = RSTSyntaxTranslator._make_table_row_separator([ 2, 1, 3 ], "-", "+")
	
	assert_str(sep).is_equal("+--+-+---+")

func test__make_table_row_separator_uses_symbols_passed() -> void:
	var sep: String = RSTSyntaxTranslator._make_table_row_separator([ 2, 1, 3 ], "~", "*")
	
	assert_str(sep).is_equal("*~~*~*~~~*")

func test__make_table_row_makes_one_column() -> void:
	var row: String = RSTSyntaxTranslator._make_table_row([ "a" ], [ 3 ], "|")
	
	assert_str(row).is_equal("| a |")

func test__make_table_row_makes_multiple_columns() -> void:
	var row: String = RSTSyntaxTranslator._make_table_row([ "a", "b" ], [ 3, 3 ], "|")
	
	assert_str(row).is_equal("| a | b |")

func test__make_table_row_uses_one_character_padding_at_least() -> void:
	var row: String = RSTSyntaxTranslator._make_table_row([ "a" ], [ 0 ], "|")
	
	assert_str(row).is_equal("| a |")

func test__make_table_row_uses_widths_passed() -> void:
	var row: String = RSTSyntaxTranslator._make_table_row([ "a", "b" ], [ 5, 4 ], "|")
	
	assert_str(row).is_equal("| a   | b  |")

func test__make_table_row_uses_character_passed() -> void:
	var row: String = RSTSyntaxTranslator._make_table_row([ "a", "b" ], [ 5, 4 ], ":")
	
	assert_str(row).is_equal(": a   : b  :")

func test__make_table_content_works_with_square_matrix() -> void:
	var content: String = RSTSyntaxTranslator._make_table_content([
		[ "a", "b" ],
		[ "c", "d" ]
	], "-", "|", "+")
	
	assert_str(content).is_equal("\
+---+---+
| a | b |
+---+---+
| c | d |
+---+---+
")

func test_normalize_code_member_works_with_full_names() -> void:
	var full_name: String = "Class.InnerClass.Enum.CONSTANT"
	
	assert_str(RSTSyntaxTranslator._normalize_code_member(full_name))\
		.is_equal("Class_InnerClass_Enum_CONSTANT")

func test_normalize_code_member_works_with_array_types() -> void:
	var type_name: String = "Class.InnerClass.Enum[]"
	
	assert_str(RSTSyntaxTranslator._normalize_code_member(type_name))\
		.is_equal("Array[Class_InnerClass_Enum]")

func test_normalize_code_member_works_with_dict_types() -> void:
	var type_name: String = "Dictionary[Class.InnerClass.Enum, String]"
	
	assert_str(RSTSyntaxTranslator._normalize_code_member(type_name))\
		.is_equal("Dictionary[Class_InnerClass_Enum, String]")

func test_make_code_member_label_target_works_with_full_names() -> void:
	var full_name: String = "Class.InnerClass.Enum.CONSTANT"
	
	assert_str(RSTSyntaxTranslator._make_code_member_label_target(full_name))\
		.is_equal("godocs_Class_InnerClass_Enum_CONSTANT")

func test_make_code_member_label_target_works_with_short_names() -> void:
	var short_name: String = "CONSTANT"
	
	assert_str(RSTSyntaxTranslator._make_code_member_label_target(short_name))\
		.is_equal("godocs_CONSTANT")

func test_make_code_member_label_works_with_full_names() -> void:
	var full_name: String = "Class.InnerClass.Enum.CONSTANT"
	
	assert_str(RSTSyntaxTranslator.make_code_member_label(full_name))\
		.is_equal(".. _godocs_Class_InnerClass_Enum_CONSTANT:")

func test_make_code_member_label_works_with_short_names() -> void:
	var short_name: String = "CONSTANT"
	
	assert_str(RSTSyntaxTranslator.make_code_member_label(short_name))\
		.is_equal(".. _godocs_CONSTANT:")

func test_make_code_member_ref_works_with_full_names() -> void:
	var full_name: String = "Class.InnerClass.Enum.CONSTANT"
	
	assert_str(RSTSyntaxTranslator.make_code_member_ref(full_name, "CONSTANT"))\
		.is_equal(":ref:`CONSTANT <godocs_Class_InnerClass_Enum_CONSTANT>`")

func test_make_code_member_type_ref_works_with_type_names() -> void:
	var type_name: String = "Dictionary[Class.InnerClass.Enum, String]"
	
	print(RSTSyntaxTranslator.make_code_member_type_ref(type_name))
	
	assert_str(RSTSyntaxTranslator.make_code_member_type_ref(type_name))\
		.is_equal(":ref:`Dictionary <godocs_Dictionary>`[:ref:`Class_InnerClass_Enum <godocs_Class_InnerClass_Enum>`, :ref:`String <godocs_String>`]")
