extends Node
class_name PremiumSignalListener

signal premium_purchase_successful
signal premium_purchase_failed
signal premium_status_found(has_premium: bool)

func _enter_tree() -> void:
	PurchaseController.premium_purchase_successful.connect(premium_purchase_successful.emit)
	PurchaseController.premium_purchase_failed.connect(premium_purchase_failed.emit)
	PurchaseController.premium_status_found.connect(premium_status_found.emit)
	premium_status_found.emit(PurchaseController.has_premium)
