
extends GdUnitTestSuite

var db: ClassDocDB

func test_get_class_document_returns_right_doc() -> void:
	db = ClassDocDB.new()
	
	var doc := XMLDocument.new()
	doc.root = XMLNode.new()
	doc.root.attributes.set("name", "Class")
	
	db.data.append(doc)
	
	assert_that(db.get_class_document("Class")).is_equal(doc)

func test_get_class_document_returns_null() -> void:
	db = ClassDocDB.new()
	
	assert_that(db.get_class_document("Class")).is_null()

func test_get_current_class_document_returns_right_doc() -> void:
	db = ClassDocDB.new()
	
	var doc := XMLDocument.new()
	doc.root = XMLNode.new()
	doc.root.attributes.set("name", "Class")
	
	db.data.append(doc)
	db.current_class = "Class"
	
	assert_that(db.get_current_class_document()).is_equal(doc)

func test_get_current_class_document_returns_null() -> void:
	db = ClassDocDB.new()
	
	assert_that(db.get_current_class_document()).is_null()

func test_get_class_inheritage_returns_empty() -> void:
	db = ClassDocDB.new()
	
	var doc := XMLDocument.new()
	doc.root = XMLNode.new()
	doc.root.attributes.set("name", "Class")
	
	db.data.append(doc)
	
	assert_array(db.get_class_inheritage("Class")).is_empty()

func test_get_class_inheritage_returns_parents() -> void:
	db = ClassDocDB.new()
	
	var child_doc := XMLDocument.new()
	child_doc.root = XMLNode.new()
	child_doc.root.attributes.set("name", "Child")
	child_doc.root.attributes.set("inherits", "Parent")
	var parent_doc := XMLDocument.new()
	parent_doc.root = XMLNode.new()
	parent_doc.root.attributes.set("name", "Parent")
	parent_doc.root.attributes.set("inherits", "GrandParent")
	var grandparent_doc := XMLDocument.new()
	grandparent_doc.root = XMLNode.new()
	grandparent_doc.root.attributes.set("name", "GrandParent")
	
	db.data.append(child_doc)
	db.data.append(parent_doc)
	db.data.append(grandparent_doc)
	
	assert_array(db.get_class_inheritage("Child"))\
		.contains_exactly([ "Parent", "GrandParent" ])

func test_get_class_member_dict_includes_all_members() -> void:
	db = ClassDocDB.new()
	
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
	
	var result: Dictionary[String, Array] = db.get_class_member_dict([], "Class")
	
	assert_array(result["members"]).contains([ "store_something" ])
	assert_array(result["methods"]).contains([ "do_something" ])

func test_get_class_member_dict_excludes_filtered_members() -> void:
	db = ClassDocDB.new()
	
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
	
	var result: Dictionary[String, Array] = db.get_class_member_dict(
		[ "members" ], "Class"
	)
	
	assert_dict(result).contains_not_keys([ "methods" ])
	assert_array(result["members"]).contains([ "store_something" ])
