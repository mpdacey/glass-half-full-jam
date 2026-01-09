extends Node
class_name GlobalSignalInterfacer

signal global_signal_emitted()
signal global_signal_emitted_with_value(value: Variant)

@export var global_signal_name: String

func _ready() -> void:
	connect_to_global_signal()
	connect_to_global_signal_with_value()

func emit_global_signal() -> void:
	if not GlobalSignalBus.has_signal(global_signal_name):
		printerr(str("Attempted to emit global signal that doesn't exist: ", global_signal_name))
	
	GlobalSignalBus.emit_signal(global_signal_name)

func emit_global_signal_with_value(value: Variant) -> void:
	if not GlobalSignalBus.has_signal(global_signal_name):
		printerr(str("Attempted to emit global signal that doesn't exist: ", global_signal_name))
	
	GlobalSignalBus.emit_signal(global_signal_name, value)

func connect_to_global_signal() -> void:
	if not GlobalSignalBus.has_signal(global_signal_name):
		printerr(str("Attempted to connect to global signal that doesn't exist: ", global_signal_name))
	
	GlobalSignalBus.connect(global_signal_name, self.global_signal_emitted.emit)

func connect_to_global_signal_with_value() -> void:
	if not GlobalSignalBus.has_signal(global_signal_name):
		printerr(str("Attempted to connect to global signal that doesn't exist: ", global_signal_name))
	
	GlobalSignalBus.connect(global_signal_name, self.global_signal_emitted_with_value.emit)
