# Import Sys to sus.stdout
import sys
import json
import requests

# Importing Variables from os
# import os



# Connecting to the Short IO API Links:

url = "https://api.short.io/api/links?domain_id=182191&limit=5&dateSortOrder=desc"
headers = {
    "accept": "application/json",
    "Authorization": "SHORT_API_KEY"
}

response = requests.get(url, headers=headers)



alfred_items = []

for item in response:
    print (item)
    result = {
        "uid": item[id],
        "title": item["title"],
        "subtitle": item["originalURL"],
        "arg": item[id],
    }

    alfred_items.append(result)

# response = json.dumps({
#     "items": alfred_results
# })


sys.stdout.write(response)