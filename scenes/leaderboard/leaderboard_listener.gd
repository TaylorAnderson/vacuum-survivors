extends Node2D

func _on_leaderboard_leaderboard_closed():
	Events.change_scene.emit(MainScene.State.TITLE)
