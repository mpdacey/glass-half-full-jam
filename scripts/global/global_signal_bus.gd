extends Node

@warning_ignore_start("unused_signal")
signal speed_scale_updated(changed_speed_scale: float)
signal terrain_gameover
signal terrain_retry
signal terrain_reset

#region Scene Management
signal scene_change_request_play
signal scene_change_request_title(snackbar_option: SnackbarUIController.SnackbarButtonType)
signal scene_changed_play
signal scene_changed_title
#endregion

signal trigger_score_request

#region Lives System
signal spend_life_requested
signal spend_life_granted
signal spend_life_denied
#endregion

#region Connection Related
signal time_check_connection
signal time_established_connection
signal time_no_connection
signal time_no_response
signal time_timed_out
#endregion

signal snackbar_button_pressed(button_type: SnackbarUIController.SnackbarButtonType)
