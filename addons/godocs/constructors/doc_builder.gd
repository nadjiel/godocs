## Can be used to separate the building process of documentations in blocks.
## 
## The [DocBuilder] class can be seen as an [b]interface[/b] that helps
## [b]breaking down the documentation building process[/b] into
## [b]smaller steps[/b] that can then be used to construct a whole document
## to be output with the help of a [DocConstructor].[br]
## [i]See also [DocConstructor][/i]
class_name DocBuilder
extends RefCounted

## The [method build_all] method is a static helper that can join the output
## of multiple [param builders] from an [Array] into a single [String] output.
## [br]
## In order to do that, this method also needs information about the classes
## that are being documented, which can be passed through the [param db]
## parameter.[br]
## [i]See also [ClassDocDB][/i]
static func build_all(builders: Array[DocBuilder], db: ClassDocDB) -> String:
	return builders.reduce((
		func(prev: String, next: DocBuilder) -> String:
			return prev + next.build(db)
	), "")

## The [method build] method is the entry point of this class when it comes to
## [b]generating its output[/b] documentation [String].[br]
## It's by [b]overriding[/b] this method that concrete [DocBuilder]s
## can [b]define their output[/b].[br]
## In order for the implementations of this method to know all they need about
## the classes that are being documented, a [ClassDocDB] instance is passed
## to this method via the [param db] parameter.[br]
## [i]See also [ClassDocDB][/i]
func build(db: ClassDocDB) -> String: return ""
