import requests
from bs4 import BeautifulSoup
import json  # 用來存 JSON

# 1. 目標網址
url = "https://www.ptt.cc/bbs/hotboards.html"

# 2. 抓取網頁
resp = requests.get(url)
soup = BeautifulSoup(resp.text, "html.parser")

# 3. 解析資料
boards = soup.select(".board")
results = []

for b in boards:
    name = b.select_one(".board-name").text
    index_url = "https://www.ptt.cc" + b.get("href")
    results.append({
        "name": name,
        "url": index_url
    })

# 4. 存成 JSON
with open("ptt_boards.json", "w", encoding="utf-8") as f:
    json.dump(results, f, ensure_ascii=False, indent=2)

print("已存成 ptt_boards.json，共抓取", len(results), "個看板")
