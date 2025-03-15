import os
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

def upload_files():
    base_url = "http://localhost:8080/api/"
    target_dirs = ["Atlas", "Chronos", "Human Player", "Pit"]
    active_folder = os.getcwd()
    
    for directory in target_dirs:
        dir_path = os.path.join(active_folder, directory)
        if os.path.isdir(dir_path):
            for root, _, files in os.walk(dir_path):
                for file in files:
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            file_content = f.read()
                        response = requests.post(
                            f"{base_url}{apis[directory]}",
                            headers={"Content-Type": "application/json"},
                            data=file_content
                        )
                        print(f"Uploaded {file_path}: {response.status_code} - {response.text}")
                    except Exception as e:
                        print(f"Failed to upload {file_path}: {e}")

def download_files():
    for i in apis.values():
        content = requests.get(f"http://localhost:8080/api/{i}").content
        #print(requests.get(f"http://localhost:8080/api/{i}").content)
        with open(f"{os.getcwd()}/database/{apisreversed[i]}.json","wb") as file:
            file.write(content)

if __name__ == "__main__":
    upload_files()
    download_files()
