try:
    import requests
    import json
    from authentication import authenticate,IAM_ENDPOINT
    import sys
except ImportError as e:
    print(f"Failed to import: {str(e)}")
    exit(1)


def get_project_ids():
    # Get User token
    token = authenticate()

    projects_headers = {
        'X-Auth-Token': token,
        'X-Subject-Token': token
    }
    response = requests.request(
        "GET", f"{IAM_ENDPOINT}/projects", headers=projects_headers, data={})

    # Loading IAM projects in JSON
    projects = response.json()

    # Filtering IAM projects
    projects_list = {}
    for project in projects['projects']:
        projects_list[project['name']] = project['id']

    jsondata = json.dumps(projects_list)
    sys.stdout.write(jsondata)


if __name__ == "__main__":
    get_project_ids()
