extends Node
class_name FirebaseManager

const COLLECTION_NAME = "users"
const DEBUG_USER_NAME = "test"
const HIGHSCORE_KEY = "highscore"
const DEBUG_USER_ID = "4ocLZoLE6zbqOfEXG8Bop4F6jJ12"

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	
	#var firestore_collection : FirestoreCollection = Firebase.Firestore.collection(COLLECTION_NAME)
	#firestore_collection.error.connect(on_error)
	#var doc := await firestore_collection.get_doc("lel")
	#doc["highscore"] = 0.8
	#firestore_collection.update(doc)

@warning_ignore("untyped_declaration")
func on_error(error_result) -> void:
	print(error_result)
