## Helps with the creation of documentation for multiple classes.
## 
## The [ClassDocConstructor] is a specialized [b]implementation[/b] of the
## [DocConstructor] that can be used to create [b]documentation for multiple
## classes[/b] at once using [b]a single mold[/b] (described by its
## [DocBuilder]s).[br]
## [i]See also: [DocConstructor] and [DocBuilder].[/i]
class_name ClassDocConstructor
extends DocConstructor

## The [method construct] method overrides its parent
## [method DocConstructor.construct] in order to make this class capable of
## [b]creating multiple output documents[/b] with only one call to it.[br]
## Each generated document is [b]named after the class[/b] on which it was based,
## unless when these names include invalid characters (such as
## [code]"/"[/code], because file names can't include them), in which case,
## they aren't even created (invalid class names can appear when trying to
## generate documentation from classes that don't have a defined
## [code]class_name[/code].[br]
## Just like its super counterpart, this method also needs a [ClassDocDB]
## instance in order to know the classes existent in the code base.[br]
## [i]See also: [method DocConstructor.construct].[/i]
func construct(db: ClassDocDB) -> Error:
	var class_documents: Array[XMLDocument] = db.get_class_document_list()
	
	var error: Error = OK
	
	for document: XMLDocument in class_documents:
		var class_node: XMLNode = document.root
		
		_doc_name = class_node.attributes.get("name", "")
		
		db.current_class = _doc_name
		
		# Ignore classes without class_name, as their name
		# would be the "path/to/them", which is not valid for
		# the file system.
		if _doc_name.contains("/"):
			continue
		
		error = super.construct(db)
		
		if error != OK:
			return error
	
	return error
