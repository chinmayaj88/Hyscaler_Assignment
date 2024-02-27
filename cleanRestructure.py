import sys
import pandas as pd
import json
import os



if len(sys.argv) < 2:
    print("Usage: python script.py <CSV file path>")
    sys.exit(1)

csv_path = sys.argv[1]

df = pd.read_csv(csv_path)

# Checks if the json_file directory exists, if not then  creates it
json_dir = "./json_file"
if not os.path.exists(json_dir):
    os.makedirs(json_dir)

# Extracts the name of the input file
base_name = os.path.splitext(os.path.basename(csv_path))[0]

# Sets the path to save the JSON file inside of the json_file directory
output_json_path = os.path.join(json_dir, f'{base_name}.json')

# Checks if the directory exists or not
if not os.path.exists(json_dir):
    os.makedirs(json_dir)

# Checks the URLs using the regex and extracts the prefixes like ai, php, python, etc.
df['Base_URL'] = df['URL'].str.extract(r'(https://example.com/data/\w+)')

# Groups the same prefix URL's as one
grouped_data = df.groupby('Base_URL')

result = []
for _, group in grouped_data:
    url_dict = {'URL': group['Base_URL'].iloc[0]}
    for _, row in group.iterrows():
        url = row['URL']
        desc = row['Description']
        key_name = url.split('/')[-1]  # Get the last part of the URL after the prefix
        if key_name == url_dict['URL'].split('/')[-1]:  # Checks if it's the main URL
            key_name = 'overview'
        # Removes any unknown characters from the key name
        key_name = ''.join(char for char in key_name if char.isalnum() or char == '_')
        # Removes any unknown characters from the description
        desc = ''.join(char for char in desc if char.isalnum() or char in (' ', '-', '_'))
        url_dict[key_name] = desc
    result.append(url_dict)

# Creates the JSON file 
with open(output_json_path, 'w') as json_file:
    json.dump(result, json_file, indent=2)

print('JSON file created successfully:', output_json_path)
