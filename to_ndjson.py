import json
import os
folder = "."
for filename in os.listdir(folder):
    if filename.endswith(".json"):
        print("processing",filename)
        with open(os.path.join(folder, filename), 'r') as f:
            data = json.load(f)
        bulk_data = []
        for doc in data:
            action = {"index":{}}
            bulk_data.append(json.dumps(action))
            bulk_data.append(json.dumps(doc))
        # Add a newline character at the end of the request
        bulk_data.append('\n')
        with open(os.path.join(folder, filename) + '.ndjson', 'w') as f:
            f.write('\n'.join(bulk_data))
        print("done.")
