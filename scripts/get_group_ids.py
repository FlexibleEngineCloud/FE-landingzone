try:
    import requests
    import json
    from authentication import authenticate
    import sys
except ImportError as e:
    print(f"Failed to import: {str(e)}")
    exit(1)

IAM_ENDPOINT = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"


def get_group_ids():
    # Get User token
    token = authenticate()

    roles_headers = {
        'X-Auth-Token': token,
        'X-Subject-Token': token
    }
    response = requests.request(
        "GET", f"{IAM_ENDPOINT}/groups", headers=roles_headers, data={})

    # Raise an exception if the request fails
    response.raise_for_status()

    # Loading IAM groups in JSON
    groups = response.json()

    # Filtering IAM groups
    groups_list = {}
    for group in groups['groups']:
        groups_list[group['name']] = group['id']

    jsondata = json.dumps(groups_list)
    sys.stdout.write(jsondata)


if __name__ == "__main__":
    get_group_ids()
