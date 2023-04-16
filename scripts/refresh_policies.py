import requests
import json
from authentication import authenticate


def get_iam_policies():
    endpoint = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"

    # Get User token
    token = authenticate()

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

        # Graping only "Admin" and "FullAccess" roles
        if "Admin" in str(role_dict['display_name']) or "FullAccess" in str(role_dict['display_name']):
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
        print("An error occurred while writing to the file 'policies.json'.")
        exit(1)


if __name__ == "__main__":
    get_iam_policies()
