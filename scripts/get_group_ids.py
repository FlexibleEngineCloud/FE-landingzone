import requests
import json
from authentication import authenticate
import sys

def get_group_ids():
    endpoint = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
    
    # Get User token
    token = authenticate()

    roles_headers = {
        'X-Auth-Token': token,
        'X-Subject-Token': token
    }
    response = requests.request(
        "GET", f"{endpoint}/groups", headers=roles_headers, data={})

    # Loading IAM groups in JSON
    groups = response.json()

    # Filtering IAM groups
    groups_list = {}
    for group in groups['groups']:
        groups_list[group['name']] = group['id']

    # ---- Altering groups.json by adding new retrieved group id value
    # Reading groups.json
    """
    try:
        groups_file = open('/home/cloud/Desktop/FE-landingzone/terraform/config/groups.json')
    except IOError:
        print("An error occurred while reading 'groups.json'.")
        exit(1)
    """
    # Adding id value
    """
    groups_data = json.load(groups_file)
    for group in groups_data:
        for item in groups_list:
            if item['name'] == group['name']:
                group['id'] = item['id']
                break
    """

    jsondata = json.dumps(groups_list)
    sys.stdout.write(jsondata)
    """
    # Saving altered groups in groups.json file
    try:
        with open('/home/cloud/Desktop/FE-landingzone/terraform/config/groups.json', 'w') as f:
            json.dump(groups_data, f, indent=2, sort_keys=True)
            print("groups.json was altered successfully!")
    except IOError:
        print("An error occurred while writing to the file 'groups.json'.")
        exit(1)
    """

if __name__ == "__main__":
    get_group_ids()