
class_name RSTClassIndexBuilder
extends RSTDocBuilder

func _build_class_list(db: ClassDocDB) -> String:
	var result: String = RSTSyntaxTranslator.make_toctree({
		"maxdepth": "1",
		"glob": "",
	}, [ "*" ])
	
	return result

func build(db: ClassDocDB) -> String:
	var title_output: String = RSTSyntaxTranslator.make_heading("Class Index", 1)
	var list_output: String = _build_class_list(db)
	
	var result: String = "\n%s\n\n%s\n" % [
		title_output,
		list_output
	]
	
	return result
