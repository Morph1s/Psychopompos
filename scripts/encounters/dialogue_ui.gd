class_name DialogueUI
extends Control

signal end_dialogue
signal an_action_occured(action:String,value: String,)


@onready var dialogue_text_box: RichTextLabel = $DialogueTextBox
@onready var answer_choices: VBoxContainer = $AnswerChoices

# loading ressource
const HEKATES_CHOICE = preload("res://resources/dialogue/Hekates_Choice.tres")
const THREE_SISTERS = preload("res://resources/dialogue/three_sisters.tres")
const PRESEPHONES_BANQUET = preload("res://resources/dialogue/persephones_banquet.tres")
const THE_HIGH_PRIESTESS = preload("res://resources/dialogue/the_high_priestess.tres")

const encounters:Array = [HEKATES_CHOICE,THREE_SISTERS, PRESEPHONES_BANQUET, THE_HIGH_PRIESTESS]

var tree:DialogueTree
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var current_text_box: String 
var current_block_indent:int = 0


func _ready() -> void:
	#fill dialogue_tree with proper file
	tree = encounters[rng.randi_range(0,encounters.size()-1)]
	# set initial text
	current_text_box = tree.dialogue_tree[current_block_indent].text_block
	update_text_box()
	# create answers
	update_answers()



func update_dialogue_encounter(possible_events: Array, triggering_response: DialogueResponse):
	# resolve respons' consequences
	triggering_response.resolve_consequences()
	
	# evaluate if encounter is still going
	if possible_events.is_empty():
		end_dialogue.emit()
		return
	# if multiple next choose one at random
	var next_event = spin_the_wheel(possible_events)
	# set new textbox in tree
	current_block_indent = next_event
	# set new dialogue and answers
	current_text_box = tree.dialogue_tree[current_block_indent].text_block
	update_text_box()
	update_answers()



#region Helper Functions
# takes one random thing out of an array
func spin_the_wheel(pool : Array) -> int:
	var result = rng.randi_range(0 , pool.size()-1)
	result = pool[result]
	return result


# Fills TextBox with the Argument
func update_text_box():
	dialogue_text_box.clear()
	dialogue_text_box.append_text(current_text_box)

# Fills Answers with buttons
func update_answers():
	#remove previous answers
	for node in answer_choices.get_children():
		if node is Button:
			answer_choices.remove_child(node)
	# create new button for each Answer in possibleAnswers
	for response in tree.dialogue_tree[current_block_indent].possible_answers:
		var new_response : Button = Button.new()
		# lappearance of button
		new_response.text = response.displayed_response
		new_response.add_theme_font_size_override("font_size",6)
		new_response.alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		# connects the buttons with exeptional parameters
		var next_block_ids = response.next_block
		new_response.pressed.connect(func(): _on_some_answer_pressed(next_block_ids, response))
		
		answer_choices.add_child(new_response)


#region Signals

func _on_answer_pressed() -> void:
	pass

func _on_some_answer_pressed(next_blocks: Array, trigger: DialogueResponse):
	update_dialogue_encounter(next_blocks, trigger)
#endregion
