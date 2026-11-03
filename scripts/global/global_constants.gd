extends Node

const COMPLETE_CYCLE_DISTANCE = 400.0
const COMPLETE_CYCLE_DEFAULT_TIME = 20.0
const LEADERBOARD_ID = "CgkInsTW6vgPEAIQAA"
const SNACKBAR_BUTTON_META_KEY = "auto_selected_snackbar_button"
const SHADER_BEND_MULTIPLIER_KEY = "bend_multiplier"

enum TimeConnectionResponses
{
	OK,
	NO_CONNECTION,
	NO_RESPONSE,
	TIMEOUT = 3
}
