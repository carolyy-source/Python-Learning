# 練習爬蟲：威秀影城
import requests
from bs4 import BeautifulSoup
import json  # 用來存 JSON

# 1. 目標網址
res = requests.get("https://www.rottentomatoes.com/")
headers = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36"
}

# 2. 抓取網頁
html = res.text
soup = BeautifulSoup(html, "html.parser")

movie_spans = soup.find_all("span", {"class": "p--small"})

# 3.直接印文字
for span in movie_spans:
    print(span.text.strip())  

# 4. 建立一個 list 存文字
movie_list = [m.text.strip() for m in movie_spans]

# 5. 存成 JSON 檔，每層縮排 2 個空格
with open("movies.json", "w", encoding="utf-8") as f:
    json.dump(movie_list, f, ensure_ascii=False, indent=2)

print("已存成 movies.json，共抓取", len(movie_list), "筆資料")
