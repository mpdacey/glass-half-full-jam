extends Node
class_name CallableOnConnectionExecuter

func execute_method_on_connection(callable: Callable) -> void:
	InternetConnectionChecker.connection_established.connect(callable, CONNECT_ONE_SHOT)
	InternetConnectionChecker.emit_when_established()

func execute_method_on_connection_by_node(node_path: NodePath, callable_name: StringName, args : Array[Variant] = []) -> void:
	var node : Node = get_node(node_path)
	
	if not node.has_method(callable_name):
		printerr(str(
			"Tried calling method `", callable_name,
			"` from node `", node,
			"` even though that method doesn't exist."
		))
		return
	
	execute_method_on_connection(node.callv.bind(callable_name, args))
