extends Node2D

var tracks = []
func _ready():
	var path = "res://assets/msc"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			#break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with(".") and !file_name.ends_with(".import"):
			#if !file_name.ends_with(".import"):
			tracks.append(load(path + "/" + file_name))
	dir.list_dir_end()
	
	randomize()
	var rand_index:int = randi() % tracks.size()
	var audiostream = tracks[rand_index]
	$Music.set_stream(audiostream)
	$Music.play()
