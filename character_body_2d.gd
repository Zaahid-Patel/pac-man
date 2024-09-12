extends CharacterBody2D

const SPEED = 300
var direction = Vector2.ZERO
var pending_direction = Vector2.ZERO

var tile_map_layer: TileMapLayer

func _ready():
	# Ensure correct reference to your TileMapLayer node
	tile_map_layer = $Walls  # Adjust the path if the TileMapLayer is not a direct child
	
	if tile_map_layer == null:
		print("Error: TileMapLayer not found. Check the node path.")
		return
	
	# Snap the character's position to the grid when the game starts
	position = position.snapped(Vector2(16, 16))

func _physics_process(delta):
	get_input()
	# Check if the direction is clear, and move if it is
	if is_path_clear(direction):
		self.velocity = direction * SPEED
	else:
		self.velocity = Vector2.ZERO  # Stop at wall
	
	move_and_slide()

	# Snap to the grid after movement to ensure alignment
	position = position.snapped(Vector2(16, 16))

func get_input():
	var input_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		input_direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_up"):
		input_direction = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		input_direction = Vector2.DOWN
	
	if input_direction != Vector2.ZERO and is_path_clear(input_direction):
		direction = input_direction

func is_path_clear(direction: Vector2) -> bool:
	if tile_map_layer == null:
		print("Error: TileMapLayer reference is null.")
		return false

	# Calculate the position to check for collisions
	var next_cell = global_position + direction * 16  # Assuming a grid size of 16x16 pixels
	next_cell = next_cell.snapped(Vector2(16, 16))  # Snap to grid for precision
	
	# Convert local position to TileMap coordinates
	var map_position = tile_map_layer.local_to_map(next_cell)
	
	# Get the tile ID at the next position
	var tile_id = tile_map_layer.get_cell_source_id(map_position)
	print("Tile ID at position: ", map_position, " is ", tile_id)
	
	# Only allow movement into tiles with ID 5 (walkable)
	return tile_id == 5
