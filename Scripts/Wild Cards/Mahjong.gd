extends WildCard

func activate() -> void:
	var seen_tiles = {}  # Dictionary to store tiles by their values
	var has_duplicates = false

	for node : Element in GameManager.hand.elements:
		var tile = node
		var topValue = tile.topValue
		var bottomValue = tile.bottomValue

		# Create a key that represents the tile (ensuring order doesn't matter)
		var tile_key = str(min(topValue, bottomValue)) + ":" + str(max(topValue, bottomValue))

		# Check if this exact tile configuration has already been seen
		if tile_key in seen_tiles:
			has_duplicates = true  # Found a duplicate!
		else:
			seen_tiles[tile_key] = true  # Store this tile

	# Bonus multiplier for duplicate tiles
	if has_duplicates:
		addMult(14)  # Adjust multiplier as needed
		shake()  
		accelerate()
