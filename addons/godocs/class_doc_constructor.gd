
class_name ClassDocConstructor
extends DocConstructor

func construct(db: ClassDocDB) -> Error:
	var class_documents: Array[XMLDocument] = db.get_class_document_list()
	
	var error: Error = OK
	
	for document: XMLDocument in class_documents:
		var class_node: XMLNode = document.root
		
		_doc_name = class_node.attributes.get("name", "")
		
		error = super.construct(db)
		
		if error != OK:
			return error
	
	return error
