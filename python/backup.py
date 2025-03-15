import os
import time
import requests
import json

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
        content = requests.get(f"https://containers.tail53c89.ts.net/api/{i}").content
        #print(requests.get(f"http://localhost:8080/api/{i}").content)
        with open(f"{os.getcwd()}/backups/{backup_id}/{apisreversed[i]}.json","wb") as file:
            file.write(content)

def upload_files():
    pass

if __name__ == "__main__":
    valid_input = False
    while not valid_input:
        option = input("Would you like to backup or restore?(enter \"r\" for restore, leave blank for backup)")
        if option == "":
            download_files()
            valid_input = True
        elif option == "r":
            upload_files()
            valid_input = True
