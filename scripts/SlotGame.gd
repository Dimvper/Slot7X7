class_name SlotGame extends Container # This is the main game class | controller of the game


var _playController: PlayController = null
# Called when the node enters the scene tree for the first time.
func _ready():
	_initializeControllers()

func _initializeControllers(): 
	_playController = PlayController.new()
	_playController.name = "PlayController"
	add_child(_playController, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Button_pressed():
	print("Button pressed")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_playController.clearLastPlay()
		_playController.makePlay()



class Piece extends Node2D:
	var VELOCITY = 12
	var symbol = randi() % 6 + 1 # #I should add weight to he symbols so its no so random
	var _pieceScene = null
	var finalPosition = Vector2(0, 0)
	var matrixPos = Vector2(0, 0)
	var _isInTree = false
	
	signal last_piece_reached

	func _init():
		match (symbol): # This can be passed to a AnimatedSprite2D and the animation can be played
			1:
				_pieceScene = load("res://scenes/blocks/wood.tscn")
			2:
				_pieceScene = load("res://scenes/blocks/sheep.tscn")
			3:
				_pieceScene = load("res://scenes/blocks/meat.tscn")
			4:
				_pieceScene = load("res://scenes/blocks/barrel.tscn")
			5:
				_pieceScene = load("res://scenes/blocks/archer.tscn")
			6:
				_pieceScene = load("res://scenes/blocks/warrior.tscn")
			{}:
				_pieceScene = load("res://scenes/blocks/wood.tscn")

	func _enter_tree():
		var piece = _pieceScene.instantiate()
		_isInTree = true
		add_child(piece, true)

	func checkNeighbours():
		#Check if the piece has a neighbour with the same symbol
		pass
	
	func _process(delta):
		if position.y < finalPosition.y&&_isInTree:
			position.y += VELOCITY
		elif matrixPos == Vector2(6,6): 
			#Send signal that last piece has reached its final position
			emit_signal("last_piece_reached")



class PlayController extends Node2D:

	var positionX = [
		10, 74, 138, 202, 266, 330, 394
	]

	var positionInitialY = [
		32, - 32, - 96, - 160, - 224, - 288, - 352
	]

	var positionFinalY = [
		390, 326, 262, 198, 134, 70, 6
	]
	var _playMatrix = []

	#listen to the last piece to reach its final position

	func _init():
		pass

	func _ready():
		pass

	func makePlay():
		for i in range(7):
			var row = []
			for j in range(7):
				row.append(createPiece(i, j))
			_playMatrix.append(row)

	func createPiece(row: int, collumn: int):
		var piece = Piece.new()
		piece.position = Vector2(positionX[collumn], positionInitialY[row])
		piece.name = "Piece_%d_%d" % [row, collumn]
		piece.finalPosition = Vector2(positionX[collumn], positionFinalY[row])
		piece.visible = true
		piece.matrixPos = Vector2(row, collumn)
		#saltos de 32 en 32
		add_child(piece, true)

		return piece
	
	func _printPlay():
		for i in range(7):
			for j in range(7):
				print(str(_playMatrix[i][j].symbol) + " ")
			print("\n")

	func clearLastPlay():
		print("Clearing the last play!")
		for i in get_children():
			if i.name.find("Piece") != - 1:
				i.queue_free()