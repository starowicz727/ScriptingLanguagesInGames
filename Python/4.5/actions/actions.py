# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions


# This is a simple example for a custom action which utters "Hello World!"

from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import json

#
# class ActionHelloWorld(Action):
#
#     def name(self) -> Text:
#         return "action_hello_world"
#
#     def run(self, dispatcher: CollectingDispatcher,
#             tracker: Tracker,
#             domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
#
#         dispatcher.utter_message(text="Hello World!")
#
#         return []

class ShowTournaments(Action):

    def name(self) -> Text:
        return "action_show_tournaments"
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        with open('tournaments.json', 'r') as json_file:
            tournaments_data = json.load(json_file)
        
        tournaments = list(tournaments_data["Tournamnets"].keys())

        response = "Available tournaments:\n" + "\n".join(tournaments)
        
        dispatcher.utter_message(response)

        return []
    
class AddPlayer(Action):
    def name(self) -> Text:
        return "action_adding_player"
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        player_name = tracker.get_slot("player_name")
        tournament = tracker.get_slot("tournament")

        with open('tournaments.json', 'r') as json_file:
            tournaments_data = json.load(json_file)

        if tournament in tournaments_data["Tournaments"]:
            players = tournaments_data["Tournaments"][tournament]["Players"]
            new_player_id = str(len(players) + 1)  
            players[new_player_id] = player_name

            tournaments_data["Tournaments"][tournament]["Players"] = players

            with open('tournaments.json', 'w') as json_file:
                json_file.write(json.dumps(tournaments_data, indent=4))

            current_state = tournaments_data["Tournaments"][tournament]["Current state"]

            response = f"I added {player_name} to {tournament}. Your number is {new_player_id}. Current state of the tournament: {current_state}"

        else:
            response = f"I'm sorry, {tournament} was not found."

        dispatcher.utter_message(response)
        
        return []

    