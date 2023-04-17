try:
    import requests
    import json
    import hcl2
    import git
except ImportError as e:
    print(f"Failed to import: {str(e)}")
    exit(1)

IAM_ENDPOINT = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
CREDENTIALS_FILE_NAME = "secretdev.tfvars"


def get_git_root():
    return git.Repo('.', search_parent_directories=True).git.rev_parse("--show-toplevel")


def load_credentials(git_repo):
    # Load Flexible Engine Credentials from .tfvars file
    with open(f"{git_repo}/{CREDENTIALS_FILE_NAME}", "r") as credentials_file:
        credentials = hcl2.load(credentials_file)

    return credentials


def authenticate():
    # Get Github repository path
    git_repo = get_git_root()

    # Load Flexible Engine credentials from .tfvars
    credentials = load_credentials(git_repo)

    # Payload to request domain scooped User Token
    payload = json.dumps({
        "auth": {
            "identity": {
                "methods": [
                    "password"
                ],
                "password": {
                    "user": {
                        "name": credentials["username"],
                        "password": credentials["password"],
                        "domain": {
                            "name": credentials["domain_name"]
                        }
                    }
                }
            },
            "scope": {
                "domain": {
                    "id": credentials["domain_id"]
                }
            }
        }
    })
    headers = {
        'Content-Type': 'application/json'
    }

    # Send the request and raise an exception if it fails
    response = requests.post(f"{IAM_ENDPOINT}/auth/tokens", headers=headers, data=payload)
    response.raise_for_status()

    # Loading User Token in token variable
    token = response.headers["X-Subject-Token"]
    
    # Function return User Token
    return token
