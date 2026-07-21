extends Node

signal premium_purchase_successful
signal premium_purchase_failed
signal premium_status_found(has_premium: bool)

const PREMIUM_ITEM_ID = "premium_mode"

var billing_client: BillingClient
var premium_price: String
var has_premium: bool = false :
	get():
		return has_premium

func _ready() -> void:
	billing_client = BillingClient.new()
	billing_client.connected.connect(_on_connected) # No params
	billing_client.disconnected.connect(_on_disconnected) # No params
	billing_client.connect_error.connect(_on_connect_error) # response_code: int, debug_message: String
	billing_client.query_product_details_response.connect(_on_query_product_details_response) # response: Dictionary
	billing_client.query_purchases_response.connect(_on_query_purchases_response) # response: Dictionary
	billing_client.on_purchase_updated.connect(_on_purchase_updated) # response: Dictionary
	billing_client.consume_purchase_response.connect(_on_consume_purchase_response) # response: Dictionary
	billing_client.acknowledge_purchase_response.connect(_on_acknowledge_purchase_response) # response: Dictionary
	
	billing_client.start_connection()

func purchase_premium_button_pressed() -> void:
	billing_client.purchase(PREMIUM_ITEM_ID)

func _on_connected() -> void:
	print("Billing client connected succesfully")
	_query_purchases()
	await billing_client.query_purchases_response
	_query_product_details()

func _on_disconnected() -> void:
	pass

func _on_connect_error(response_code: int, debug_message: String) -> void:
	_print_error("Failed to connect to billing client", response_code, debug_message)

func _query_product_details() -> void:
	billing_client.query_product_details([PREMIUM_ITEM_ID], BillingClient.ProductType.INAPP)

func _on_query_product_details_response(response: Dictionary) -> void:
	if response.response_code == BillingClient.BillingResponseCode.OK:
		print("Available products")
		for available_product : Dictionary in response.product_details:
			print(available_product)
			if available_product.product_id == PREMIUM_ITEM_ID:
				var product_details : Dictionary = available_product.one_time_purchase_offer_details_list[0]
				var product_price : String = product_details.formatted_price
				var product_currency: String = product_details.price_currency_code
				premium_price = str(product_currency, " ", product_price)
	else:
		_print_error("Product details query failed", response.response_code, response.debug_message)

func _query_purchases() -> void:
	billing_client.query_purchases(BillingClient.ProductType.INAPP)

func _on_query_purchases_response(response: Dictionary) -> void:
	if response.response_code == BillingClient.BillingResponseCode.OK:
		print("Purchase query successful")
		for purchase: Dictionary in response.purchases:
			_process_purchase(purchase)
	else:
		_print_error("Purchase query error", response.response_code, response.debug_message)
		premium_status_found.emit(false)
		has_premium = false

func _process_purchase(purchase: Dictionary) -> void:
	if not PREMIUM_ITEM_ID in purchase.product_ids:
		return
	
	if purchase.purchase_state == BillingClient.PurchaseState.PURCHASED:
		if not purchase.is_acknowledged:
			billing_client.acknowledge_purchase(purchase.purchase_token)
		else:
			premium_status_found.emit(true)
			has_premium = true
	else:
		premium_status_found.emit(false)
		has_premium = false

func _on_purchase_updated(response: Dictionary) -> void:
	if response.response_code != BillingClient.BillingResponseCode.OK:
		_print_error("Purchase update error", response.response_code, response.debug_message)
		premium_purchase_failed.emit()
		return
	
	for purchase : Dictionary in response.purchases:
		_process_purchase(purchase)

func _on_consume_purchase_response(response: Dictionary) -> void:
	pass

func _on_acknowledge_purchase_response(response: Dictionary) -> void:
	if response.response_code == BillingClient.BillingResponseCode.OK:
		print("Acknowledge purchase success")
		_handle_purchase_token(response.token, true)
	else:
		_print_error("Acknowledge purchase failed", response.response_code, response.debug_message)

func _handle_purchase_token(_purchase_token: String, purchase_successful: bool) -> void:
	if purchase_successful:
		premium_purchase_successful.emit()
		has_premium = true
	else:
		premium_purchase_failed.emit()
		has_premium = false

func _print_error(custom_message: String, response_code: int, debug_message: String) -> void:
		print(custom_message)
		print("response code: ", response_code)
		print("debug_message: ", debug_message)
