extends Node

# makes random choice of true or false with odds given by num
func chance(num):
	randomize()
	
	if randi() % 100 <= num: return true
	else: return false

# given a list of two choices, returns one or the other
func choose(choices):
	randomize()
	
	var rand_index = randi() % choices.size()
	return choices[rand_index]
