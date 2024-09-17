extends AudioStreamPlayer

@export var game_track:AudioStream
@export var menu_track:AudioStream

func change_music(new_state:MainScene.State):
	var track_to_play = null;
	if new_state == MainScene.State.GAME:
		track_to_play = game_track
	else:
		track_to_play = menu_track;
		
	if stream != track_to_play:
		stream = track_to_play;
		play();
		
