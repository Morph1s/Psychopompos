extends Control

signal end_dialogue
signal an_action_occured(action:String,value: String,)


@onready var dialogue_text_box: RichTextLabel = $DialogueTextBox
@onready var answer_choices: VBoxContainer = $AnswerChoices



const TEST_DIALOGUE = preload("res://assets/dialogues/test_dialogue.json")
const HEKATES_FLAMME = preload("res://assets/dialogues/hekates_flamme.tres")

var possible_encounters : Array = [TEST_DIALOGUE.data, HEKATES_FLAMME.data]

var dialogue_tree 
var jason = JSON.new()
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# basicaly dynamic memory for everithing in the jason-tree
var current_text_box: String = "Hello world"
var possible_answers: Array[String] = ["Helllllloooooooooo"]
var next_answer_key: Array
var resulting_action_key: Array


func _ready() -> void:
	#something... something... to fill dialogue_tree with proper json file
	var chosen_encounter = rng.randi_range(0 , possible_encounters.size()-1)
	dialogue_tree = possible_encounters[chosen_encounter]
	
	# set initial text
	current_text_box = dialogue_tree.dialogue.block1.text
	update_text_box()
	# update memory with first block
	update_memory("block1")
	# create answers
	update_answers()



func update_Dialogue_Encounter(possible_events: Array, actions: Array):
	# emit signal to execute action
	for action in actions:
		an_action_occured.emit(action[0],action[1])
	# evaluate if encounter is still going
	if possible_events == null:
		end_dialogue.emit()
		return
	# if multiple next choose one at random
	var next_event = spin_the_wheel(possible_events)
	# find new textbox in tree
	var right_block
	for block in dialogue_tree.dialogue:
		if dialogue_tree.dialogue[block].id == next_event:
			right_block = block
	# set new dialogue and answers
	current_text_box = dialogue_tree.dialogue[right_block].text
	update_text_box()
	update_memory(right_block)
	update_answers()



#region Helper Functions
# takes one random thing out of an array
func spin_the_wheel (pool : Array) -> int:
	var result = rng.randi_range(0 , pool.size()-1)
	result = pool[result]
	return result

# fills the memory array with data from the jasn file in block text_block_name
func update_memory(text_block_name : String):
	# remove previose entry
	possible_answers.clear()
	next_answer_key.clear()
	resulting_action_key.clear()
	# add new data from the json file
	for answer in dialogue_tree.dialogue[text_block_name].answers:
		possible_answers.append(dialogue_tree.dialogue[text_block_name].answers[answer].text) # reads "text" from every answer and appends to possible_answers String-Array
		next_answer_key.append(dialogue_tree.dialogue[text_block_name].answers[answer].next) # stores id's for next textbox in next_answer_key
		resulting_action_key.append(dialogue_tree.dialogue[text_block_name].answers[answer].action)


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
	var counter = 0
	for answer in possible_answers:
		var new_answer : Button = Button.new()
		# Aussehen des Buttons
		new_answer.text = answer
		new_answer.add_theme_font_size_override("font_size",12)
		new_answer.alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		# connects the buttons with exeptional parameters
		var next_answer = next_answer_key[counter]
		var next_action = resulting_action_key[counter]
		new_answer.pressed.connect(func(): _on_some_answer_pressed(next_answer, next_action))
		
		answer_choices.add_child(new_answer)
		counter += 1


#region Signals

func _on_answer_pressed() -> void:
	#update_Dialogue_Encounter()
	pass

func _on_some_answer_pressed(next_key: Array, resulting_action: Array):
	update_Dialogue_Encounter(next_key,resulting_action)
#endregion
