extends Node

@warning_ignore_start("unused_signal")
signal speed_scale_updated(changed_speed_scale: float)
signal terrain_gameover
signal terrain_retry
signal terrain_reset

#region Scene Management
signal scene_change_request_play
signal scene_change_request_title
signal scene_changed_play
signal scene_changed_title
#endregion
