import requests
import json

# Flexible Engine endpoint variable
endpoint = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
token_url = f"{endpoint}/auth/tokens?Content-Type=application/json;charset=utf8"

# Flexible Engine Credentials
username = "XXXXXXXXX"
password = "XXXXXXXXX"
domain_name = "XXXXXXXXX"
domain_id = "XXXXXXXXX"

# ------ Obtain User Token on a global domain
# Payload to request domain scooped User Token
payload = json.dumps({
    "auth": {
        "identity": {
            "methods": [
                "password"
            ],
            "password": {
                "user": {
                    "name": username,
                    "password": password,
                    "domain": {
                        "name": domain_name
                    }
                }
            }
        },
        "scope": {
            "domain": {
                "id": domain_id
            }
        }
    }
})
headers = {
    'Content-Type': 'application/json'
}

# Loading User Token in token variable
token = (requests.request("POST", token_url, headers=headers,
         data=payload)).headers["X-Subject-Token"]


# ------ Querying All IAM policies
roles_headers = {
    'X-Auth-Token': token,
    'X-Subject-Token': token
}
response = requests.request(
    "GET", f"{endpoint}/roles", headers=roles_headers, data={})

# Loading IAM policies in JSON
policies = response.json()

# Filtering IAM policies
roles_list = []
for role in policies['roles']:
    role_dict = {
        'id': role['id'],
    }
    try:
        role_dict['catalog'] = role['catalog']
    except KeyError:
        role_dict['catalog'] = None

    try:
        role_dict['description'] = role['description']
    except KeyError:
        role_dict['description'] = None

    try:
        role_dict['display_name'] = role['display_name']
    except KeyError:
        role_dict['display_name'] = None

    try:
        role_dict['policy'] = role['policy']
    except KeyError:
        role_dict['policy'] = None

    roles_list.append(role_dict)

# Grouping Policies based on Service names (Catalog).
grouped_data = {}
for role in roles_list:
    catalog = role.get('catalog')
    if catalog:
        if catalog not in grouped_data:
            grouped_data[catalog] = []
        grouped_data[catalog].append(role)

# Saving policies in policies.json file
try:
    with open('policies.json', 'w') as f:
        json.dump(grouped_data, f, indent=2, sort_keys=True)
        print("policies.json was generated successfully!")
except IOError:
    print("An error occurred while writing to the file 'result.json'.")
    exit(1)
