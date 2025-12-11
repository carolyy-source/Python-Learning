import requests
import json

# 1. 官方公開 JSON 資料集網址
url = "https://media.taiwan.net.tw/XMLReleaseAll_public/v2.0/Zh_tw/Hotel-json.zip"

# 2. 下載 ZIP 檔
resp = requests.get(url, verify=False)  # 忽略 SSL
with open("hotel_data.zip", "wb") as f:
    f.write(resp.content)

print("已下載 hotel_data.zip")

# 3. 解壓縮並讀 JSON — 假設你手動解壓縮後有 .json 檔
#    或者你可以用 python zipfile 模組自動解壓
import zipfile
with zipfile.ZipFile("hotel_data.zip", 'r') as zip_ref:
    zip_ref.extractall("hotel_data")

print("已解壓縮到 hotel_data/")

# 4. 讀取 JSON 檔（假設裡面有 hotel.json）
with open("hotel_data/Hotel.json", 'r', encoding="utf-8") as f:
    data = json.load(f)

print("總共讀取到 {} 筆資料".format(len(data)))

# 5. （可選）過濾欄位，只保留你需要的
filtered = []
for h in data:
    filtered.append({
        "HotelID": h.get("HotelID"),
        "Name": h.get("HotelName"),
        "Address": h.get("PostalAddress"),
        "Latitude": h.get("PositionLat"),
        "Longitude": h.get("PositionLon"),
        "Tel": h.get("Telephones"),
        "Website": h.get("WebsiteURL")
    })

# 6. 存成新的 JSON
with open("hotels_filtered.json", "w", encoding="utf-8") as f:
    json.dump(filtered, f, ensure_ascii=False, indent=2)

print("已存成 hotels_filtered.json，包含 {} 筆飯店資料".format(len(filtered)))
