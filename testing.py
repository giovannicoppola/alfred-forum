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
    "Authorization": "sk_3T0zGFKzWx528fCO"
}

response = requests.get(url, headers=headers).json()
print (type(response))
print (response)
alfred_items = []

for item in response['links']:
    print (type(item))
    print (item['id'])
    # result = {
    #     "uid": item[0]["id"],
    #     "title": item[0]["title"],
    #     "subtitle": item[0]["originalURL"],
    #     "arg": item[0]["id"],
    # }

    # alfred_items.append(result)

# response = json.dumps({
#     "items": alfred_items
# })


# sys.stdout.write(response)

"""

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
    "Authorization": "sk_3T0zGFKzWx528fCO"
}

response = requests.get(url, headers=headers).json()
#myData = (response.json())
#print (response.keys())
#print (response['links'])
print (len(response))
response = response['links']
print (type(response))
print (len(response))
print (response[0]['id'])

alfred_items = []

#for item in response:
#    print (type(item))
    # print (item['originalURL'])
    # print (item["id"])
#     result = {
#         "uid": item["id"],
#         "title": item["title"],
#         "subtitle": item["originalURL"],
#         "arg": item["id"],
#     }

#     alfred_items.append(result)

# response = json.dumps({
#     "items": alfred_results
# })


#sys.stdout.write(response)
"""