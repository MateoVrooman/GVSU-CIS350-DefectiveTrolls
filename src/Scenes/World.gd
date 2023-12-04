extends Node2D

const MAP_H = 128
const MAP_W = 128
const BOUNDS = Rect2(0, 0, MAP_W, MAP_H)

var density = 46

#@onready var tilemap = $TileMap
@onready var player = $Player
@onready var enemy_scene = preload('res://enemy1/enemy.tscn')
@onready var spawned_enemies = $Spawned_Enemies

@onready var item_scene = preload("res://Scenes/heart.tscn")
@onready var spawned_items = $Spawned_Items

func _ready():
	randomize()
	generate_map()

func generate_map():
	var tilemap = $TileMap
	var grid = make_noise_grid()
	grid = cellular_automaton(grid, 15)
	grid = clean_edges(grid)
	# print(grid)
	# find spawn points
	var spawns = find_spawns(grid)
	# print(spawns)
	spawns = spawn_player(spawns)
	spawns = spawn_enemies(spawns)
	spawns = spawn_items(spawns)
	var tiles = grid_to_tiles(grid)
	tilemap.set_cells_terrain_connect(0, tiles, 0, 0)
	fill_background(grid)


func fill_background(grid):
	var tilemap = $TileMap
	for x in range(MAP_W):
		for y in range(MAP_H):
			if grid[x][y] == 0:
				tilemap.set_cell(0, Vector2(x, y), 2, Vector2(0, 0), 0)



func grid_to_tiles(grid):
	var tiles = []
	for x in range(MAP_W):
		for y in range(MAP_H):
			if grid[x][y] == 1:
				tiles.append(Vector2(x, y))
	return tiles

func cellular_automaton(grid, count):
	# var tiles = []
	for i in range(count):
		var temp_grid = grid
		
		for j in range(MAP_H):
			for k in range(MAP_W):
				var neighbor_wall_count = 0
				for y in [-1, 0, 1]:
					for x in [-1, 0, 1]:
						if BOUNDS.has_point(Vector2(x + k, y + j)):
							if y != j or x != k:
								if temp_grid[y + j][x + k] == 0:
									neighbor_wall_count += 1
						else:
							neighbor_wall_count += 1
				if neighbor_wall_count > 4:
					grid[j][k] = 0
				else:
					grid[j][k] = 1
					# tiles.append(Vector2(j, k))
	return grid

func clean_edges(grid):
	var min_neighbors = 13
	var temp_grid = grid
	for j in range(MAP_H):
		for k in range(MAP_W):
			var neighbor_floor_count = 0
			for y in [-2, -1, 0, 1, 2]:
				for x in [-2, -1, 0, 1, 2]:
					if BOUNDS.has_point(Vector2(x + k, y + j)):
						if y != j or x != k:
							if temp_grid[y + j][x + k] == 1:
								neighbor_floor_count += 1
					
			if neighbor_floor_count < min_neighbors:
				grid[j][k] = 0
	return grid


func make_noise_grid():
	var noise_grid=[]
	var random 
	for x in range(MAP_W):
		
		# print(x)
		noise_grid.append([])
		for y in range(MAP_H):
			random = randi() % 100
			# print(y)
			if (random > density):
				noise_grid[x].append(1)
			else:
				noise_grid[x].append(0)
	return noise_grid

func find_spawns(grid):
	var spawns = []
	for j in range(MAP_H):
		for k in range(MAP_W):
			var neighbor_tiles = 0
			for y in [-2, -1, 0, 1, 2]:
				for x in [-2, -1, 0, 1, 2]:
					if BOUNDS.has_point(Vector2(x + k, y + j)):
						if grid[x + k][y + j] == 1:
							neighbor_tiles += 1
			if neighbor_tiles == 24:
				spawns.append([k, j])
	return spawns

func spawn_player(spawns):
	spawns.shuffle()
	var spawn_point = spawns.pop_front()
	player.position = Vector2(spawn_point[0] * 32, spawn_point[1] * 32)
	return spawns

func spawn_enemies(spawns):
	spawns.shuffle()
	for i in range(10):
		var spawn_point = spawns.pop_front()
		var enemy = enemy_scene.instantiate()
		enemy.position = Vector2(spawn_point[0] * 32, spawn_point[1] * 32)
		spawned_enemies.add_child(enemy)
	return spawns
	
func spawn_items(spawns):
	spawns.shuffle()
	for i in range(10):
		var spawn_point = spawns.pop_front()
		var item = item_scene.instantiate()
		item.position = Vector2(spawn_point[0] * 32, spawn_point[1] * 32)
		spawned_items.add_child(item)
	return spawns



func _on_inventory_gui_closed():
	get_tree().paused = false


func _on_inventory_gui_opened():
	get_tree().paused = true
