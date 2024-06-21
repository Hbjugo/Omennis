extends Control
class_name QuestLogUI

@onready var displayed_quest = $bg/displayed_quest
@onready var displayed_quest_title = $bg/displayed_quest/quest_title_bg/quest_title
@onready var displayed_quest_description = $bg/displayed_quest/quest_description_container/quest_description
@onready var quests_control = $bg/quests_scroll/quests_control

var quests_info: Array[Dictionary]

const QUESTS_HEIGHT = 70
const QUESTS_WIDTH = 500
const QUESTS_MARGIN = 20

var curr_quest: int

func update_ui(quest_log: Dictionary) :
	quests_info.clear()
	for quest_button in quests_control.get_children() :
		quest_button.queue_free()
	displayed_quest.visible = false
	
	for i in range(0, quest_log.size()):
		var quest_state = quest_log[quest_log.keys()[i]]
		if quest_state != game_state.QUEST_STATE.Turned :  
			var quest_info = load("res://text/quests/" + "%03d" % quest_log.keys()[i] + ".json").data
			quests_info.append(quest_info)
			
			var quest_button = Button.new()
			quest_button.add_theme_color_override("font_color", Color(0, 0, 0))
			quest_button.add_theme_font_size_override("font_size", 30)
			var quest_title = quest_info.name + (" (Accomplished)" if quest_state == game_state.QUEST_STATE.Accomplished else "") 
			quest_button.set_text(quest_title)
			quest_button.pressed.connect(_on_quest_button_pressed.bind(i))
			quest_button.set_size(Vector2(QUESTS_WIDTH, QUESTS_HEIGHT))
			quest_button.set_position(Vector2(0, QUESTS_MARGIN + i * (QUESTS_HEIGHT + QUESTS_MARGIN)))
			quests_control.add_child(quest_button)

func _on_quest_button_pressed(index: int) :
	var quest_info = quests_info[index]
	displayed_quest_title.set_text(quest_info.name)
	displayed_quest_description.set_text(
		"Difficulty: {difficulty}
		Location: {location}
		Description: {description}
		Reward: {reward}".format({"difficulty" : quest_info.difficulty, "location" : quest_info.location, 
		"description": quest_info.description, "reward": quest_info.reward}))
	if index != curr_quest :
		displayed_quest.visible = true
	else :
		displayed_quest.visible = not displayed_quest.visible
	curr_quest = index
		
