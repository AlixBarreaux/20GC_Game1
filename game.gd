extends Node2D

@onready var other: CharacterBody2D = $Other
@onready var ball: RigidBody2D = $Ball
@onready var other_shape: CollisionShape2D = $Other/CollisionShape2D

@onready var other_label : Label = $OtherScore
@onready var player_label : Label = $PlayerScore

@onready var hit_audio_player: AudioStreamPlayer = $HitAudioPlayer
@onready var rebound_audio_player: AudioStreamPlayer = $ReboundAudioPlayer
@onready var menu: Menu = $Menu


var ball_speed := 300
const OTHER_SPEED = 300
const OTHER_MIDDLE = 128/2
const MOVE_LIMIT = 25 # amount of pixels to not move (prevent AI stutters)
var paused := false

var other_score := 0
var player_score := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("esc")):
		_pause()
	
	# Bit of padding (move_limit) to prevent stuttering
	var other_direction := 0
	if (other.position.y + OTHER_MIDDLE > ball.position.y + MOVE_LIMIT):
		other_direction = -1
	elif (other.position.y + OTHER_MIDDLE < ball.position.y - MOVE_LIMIT):
		other_direction = 1
	other.velocity = Vector2(0,other_direction) * OTHER_SPEED
	other.move_and_slide()

# When the game starts, place the ball and shoot it somewhere
func _start() -> void:
	ball.start()

func _on_goal_player_body_entered(body: Node2D) -> void:
	if body == ball:
		player_score += 1
		player_label.text = str(player_score)
		ball.start()

func _on_goal_other_body_entered(body: Node2D) -> void:
	if body == ball:
		other_score += 1
		other_label.text = str(other_score)
		ball.start()

func _on_ball_hit_sound() -> void:
	hit_audio_player.play()

func _on_ball_rebound_sound() -> void:
	rebound_audio_player.play()

func _on_menu_resume() -> void:
	_pause()
	
func _pause() -> void:
	if not paused:
		paused = true
		menu.show()
		menu.focus_continue() # so we can navigate it
		Engine.time_scale = 0
	else:
		paused = false
		menu.hide()
		Engine.time_scale = 1
