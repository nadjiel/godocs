
extends Node

var text: String = "
Move the [Sprite2D].
See [annotation @GDScript.@rpc].
See [constant Color.RED].
See [enum Mesh.ArrayType].
Get [member Node2D.scale].
Call [method Node3D.hide].
Use [constructor Color.Color].
Use [operator Color.operator *].
Emit [signal Node.renamed].
See [theme_item Label.font].
Takes [param size] for the size.
Line 1.[br]
Line 2.
[lb]b[rb]text[lb]/b[rb]
Do [b]not[/b] call this method.
Returns the [i]global[/i] position.
[u]Always[/u] use this method.
[s]Outdated information.[/s]
[color=red]Error![/color]
[font=res://mono.ttf]LICENSE[/font]
[img width=32]res://icon.svg[/img]
[url]https://example.com[/url]
[url=https://example.com]Website[/url]
[center]2 + 2 = 4[/center]
Press [kbd]Ctrl + C[/kbd].
Returns [code]true[/code].

Do something for this plugin. Before using the method
you first have to [method initialize] [MyPlugin].[br]
[color=yellow]Warning:[/color] Always [method clean] after use.[br]
Usage:
[codeblock]
func _ready():
	the_plugin.initialize()
	the_plugin.do_something()
	the_plugin.clean()
[/codeblock]
"

var interpreter: SyntaxInterpreter = BBCodeSyntaxInterpreter.new()

var translator: SyntaxTranslator = RSTSyntaxTranslator.new()

func _ready() -> void:
	print("BEFORE:")
	print_rich(text)
	
	print("AFTER:")
	prints("Result:", interpreter.interpret(text).translate(translator))
