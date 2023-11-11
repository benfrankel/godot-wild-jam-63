extends Node
"""
	Globally loaded script for managing all global game data, as well as a few singletons that wouldn't work well as singletons

"""

signal level_finished_loading

var viewport : ViewportManager
var current_door_target := ""
