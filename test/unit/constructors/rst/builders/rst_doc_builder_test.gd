# GdUnit generated TestSuite
class_name RstDocBuilderTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/godocs/constructors/rst/builders/rst_doc_builder.gd'

var Builder := RSTDocBuilder

func test__make_table_row_separator_makes_one_column() -> void:
	var sep: String = Builder._make_table_row_separator([ 1 ], "-", "+")
	
	assert_str(sep).is_equal("+-+")

func test__make_table_row_separator_makes_multiple_columns() -> void:
	var sep: String = Builder._make_table_row_separator([ 1, 1, 1 ], "-", "+")
	
	assert_str(sep).is_equal("+-+-+-+")

func test__make_table_row_separator_uses_right_widths() -> void:
	var sep: String = Builder._make_table_row_separator([ 2, 1, 3 ], "-", "+")
	
	assert_str(sep).is_equal("+--+-+---+")

func test__make_table_row_separator_uses_symbols_passed() -> void:
	var sep: String = Builder._make_table_row_separator([ 2, 1, 3 ], "~", "*")
	
	assert_str(sep).is_equal("*~~*~*~~~*")

func test__make_table_row_makes_one_column() -> void:
	var row: String = Builder._make_table_row([ "a" ], [ 3 ], "|")
	
	assert_str(row).is_equal("| a |")

func test__make_table_row_makes_multiple_columns() -> void:
	var row: String = Builder._make_table_row([ "a", "b" ], [ 3, 3 ], "|")
	
	assert_str(row).is_equal("| a | b |")

func test__make_table_row_uses_one_character_padding_at_least() -> void:
	var row: String = Builder._make_table_row([ "a" ], [ 0 ], "|")
	
	assert_str(row).is_equal("| a |")

func test__make_table_row_uses_widths_passed() -> void:
	var row: String = Builder._make_table_row([ "a", "b" ], [ 5, 4 ], "|")
	
	assert_str(row).is_equal("| a   | b  |")

func test__make_table_row_uses_character_passed() -> void:
	var row: String = Builder._make_table_row([ "a", "b" ], [ 5, 4 ], ":")
	
	assert_str(row).is_equal(": a   : b  :")

func test__make_table_content_works_with_square_matrix() -> void:
	var content: String = Builder._make_table_content([
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
