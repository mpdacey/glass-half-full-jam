extends CanvasLayer

func _on_hyper_link_clicked(url: String) -> void:
	OS.shell_open(url)
