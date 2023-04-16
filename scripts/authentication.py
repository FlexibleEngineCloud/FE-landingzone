import requests
import json
import hcl2


def authenticate():
    # Flexible Engine endpoint variable
    endpoint = "https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3"
    token_url = f"{endpoint}/auth/tokens?Content-Type=application/json;charset=utf8"

    # Load Flexible Engine Credentials from .tfvars file
    with open("/home/cloud/Desktop/FE-landingzone/secretdev.tfvars", "r") as credentials_file:
        credentials = hcl2.load(credentials_file)

    credentials_file.close()

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

    # Loading User Token in token variable
    token = (requests.request("POST", token_url, headers=headers,
                              data=payload)).headers["X-Subject-Token"]

    # Function return User Token
    return token