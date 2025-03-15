import os
import sys
import time
from datetime import datetime
import requests
import json


url = "https://containers.tail53c89.ts.net"
apis = {
    "Atlas": "atlas",
    "Chronos": "chronos",
    "Pit": "pit",
    "Human Player": "hp"
}
# im lazy
apisreversed = {
    "atlas": "Atlas",
    "chronos": "Chronos",
    "pit": "Pit",
    "hp": "Human Player"
}

def download_files():
    backup_id = "backup_" + str(time.time()).split(".")[0]
    os.makedirs(os.path.join(os.getcwd(),"backups",backup_id))
    for i in apis.values():
        content = requests.get(f"{url}/api/{i}").content
        with open(f"{os.getcwd()}/backups/{backup_id}/{apisreversed[i]}.json","wb") as file:
            file.write(content)

def upload_files():
    backups = os.listdir(os.path.join(os.getcwd(),"backups"))
    print("The following backup files are present:")
    for i in backups:
        epoch_time = datetime.fromtimestamp(int(i.split("_")[1]))
        print(f"{backups.index(i) + 1}: {epoch_time}")
    index = int(input("Which number backup would you like to use? ")) - 1
    upload_folder = os.path.join(os.getcwd(),"backups",backups[index])
    for i in os.listdir(upload_folder):
        with open(os.path.join(upload_folder,i),"r") as file:
            layout = i.split(".")[0]
            jsonFile = json.loads(file.read())
            for match in jsonFile:
                a = requests.post(f"{url}/api/{apis[layout]}",str(json.dumps(match)),headers={"Content-Type": "application/json"})


if __name__ == "__main__":
    valid_input = False
    while not valid_input:
        option = input("Would you like to backup or restore?(enter \"r\" for restore, leave blank for backup): ")
        if option == "":
            download_files()
            valid_input = True
        elif option == "r":
            upload_files()
            valid_input = True
        if not valid_input:
            print("Invalid input. Please try again.")
