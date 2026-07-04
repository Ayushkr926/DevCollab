import json

# Input JSON file
INPUT_FILE = "female_memoji.json"

# Output JSON file
OUTPUT_FILE = "female_memoji.json"   # Change this if you want a new file

# Load JSON
with open(INPUT_FILE, "r", encoding="utf-8") as f:
    data = json.load(f)

modd =[]

# Add gender key
for item in data:
    m = item["skinTone"]
    if(m  not in modd):
        modd.append(m)

print(modd)


print(f"✅ Updated {len(data)} records with gender='male'")