try:
    import requests
    import json
    from authentication import authenticate, get_git_root, IAM_ENDPOINT
except ImportError as e:
    print(f"Failed to import: {str(e)}")
    exit(1)


def get_iam_policies():
    # Get User token
    token = authenticate()

    headers = {
        'X-Auth-Token': token,
        'X-Subject-Token': token
    }

    # Get IAM policies
    response = requests.get(f"{IAM_ENDPOINT}/roles", headers=headers)
    response.raise_for_status()
    policies = response.json()

    # Filter IAM policies
    roles_list = [
        {
            'id': role['id'],
            'catalog': role.get('catalog'),
            'description': role.get('description'),
            'display_name': role.get('display_name')
        }
        for role in policies['roles']
        if "Admin" in str(role.get('display_name', '')) or "FullAccess" in str(role.get('display_name', ''))
    ]

    # Group policies by catalog
    grouped_data = {}
    for role in roles_list:
        catalog = role.get('catalog')
        if catalog:
            grouped_data.setdefault(catalog, []).append(role)

    # Get Github repository path
    git_repo = get_git_root()

    # Save policies to file
    try:
        with open(f"{git_repo}/policies.json", 'w') as file:
            json.dump(grouped_data, file, indent=2,
                      sort_keys=True, default=str)
            print("policies.json was generated successfully!")
    except IOError:
        print("An error occurred while writing to the file 'policies.json'.")
        exit(1)


if __name__ == "__main__":
    get_iam_policies()
