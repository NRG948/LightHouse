import requests
import json
data = {}


mt_shortcuts = {
    "q": "Qualifications",
    "f": "Finals",
    "p": "Playoffs"
}


comments = """
spent time figuring out which direction to go
kept rotating
pushed algae and coral to opponents cs
stayed near reef…got pushed into once
bad defense
"""
print("Welcome to LightHouse data patcher")
data["dataType"] = "Atlas"
data["matchNumber"] = int(input("enter match number:"))
data["teamNumber"] = int(input("enter team number:"))
data["matchType"] = mt_shortcuts[input("Enter match type (q for quals, f for finals, p for playoffs):")]
data["driverStation"] = input("enter driver station (Format like 'Red 1'):")
data["patcher"] = input("Enter scouter name:")
data["comments"] = input("Enter comments:")
if (data["comments"] == ""):
    data["comments"] = comments
print(json.dumps(data))
a = requests.post("https://containers.tail53c89.ts.net/api/patch",json.dumps(data),headers={"Content-Type": "application/json"})
print(a.content)