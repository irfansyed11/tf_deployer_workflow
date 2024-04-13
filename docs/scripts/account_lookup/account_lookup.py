import os
import json
import logging
import requests
import argparse
from pathlib import Path
from string import digits

logger = logging.getLogger(__name__)

GITHUB_REPO = os.getenv('GITHUB_REPO', 'aws-accounts')
GITHUB_ORG = os.getenv('GITHUB_ORG', 'AllegiantTravelCo')

if os.environ.get('GITHUB_TOKEN') is None:
    raise EnvironmentError("GITHUB_TOKEN is not set in the environment")
else:
    headers = {
        "Authorization":    "Bearer " + os.getenv('GITHUB_TOKEN'),
        "Accept":           "application/vnd.github+json"
    }


def main(args):


    # Setup variables from Arguments
    logging.debug(f'Arguments:\n{json.dumps(args, default=str, indent=2)}')
    environment = args.env
    subenv      = args.subenv
    tier        = args.tier    
    app_list    = args.app_list
    app_type    = args.type

    response = requests.get(f'https://api.github.com/repos/{GITHUB_ORG}/{GITHUB_REPO}/contents/{environment}.json', headers=headers)
    response = requests.get(response.json().get('download_url'))
    account_list = response.json()
    logging.debug(f'account_list:\n{json.dumps(account_list, default=str, indent=2)}')

    applications_with_paths = app_list_to_paths(app_list, app_type)
    logging.debug(f'applications_with_paths:\n{json.dumps(applications_with_paths, default=str, indent=2)}')


    ### Process provided paths, and return names
    matrix_output = paths_to_account_names(applications_with_paths, subenv, tier, account_list)
    logging.debug(f'matrix_output:\n{json.dumps(matrix_output, default=str, indent=2)}')

    for account_name in matrix_output.keys():
        account_data = [x for x in account_list if x.get('Name') == account_name]
        if not account_data:
            raise ValueError(f'Account {account_name} not found in {environment}.json')
        matrix_output[account_name]['Id'] = account_data[0].get('Id')

    logging.debug(f'matrix_output:\n{json.dumps(matrix_output, default=str, indent=2)}')

    flattened_matrix = flatten_matrix(matrix_output)
    print(json.dumps(flattened_matrix))


    # ### Process provided IDs
    # for id in ids:
    #     account = [x for x in account_list if x.get('Id') == id]
    #     if not account:
    #         raise ValueError(f'Account {id} not found in {environment}.json')
    #     accounts += account  

    # ### Print the output
    # if args.id_only:
    #     if not args.text:
    #         response = json.dumps([account.get('Id') for account in accounts])
    #     else:
    #         response = ','.join(account['Id'] for account in accounts)
    # elif args.name_only:
    #     if not args.text:
    #         response = json.dumps([account['Name'] for account in accounts])
    #     else:
    #         response = ','.join(account['Name'] for account in accounts)
    # else: 
    #     response = json.dumps(accounts)

    # print(response)
    # return response


def flatten_matrix(matrix_output):
    # Convert the matrix output into a single list of maps. The maps contain the app, path, account id, and account name for each item in the matrix
    flattened_matrix = []
    for account_name in matrix_output.keys():
        for app in matrix_output[account_name]['Applications']:
            flattened_matrix.append({
                "application": app,
                "path": matrix_output[account_name]['Applications'][app],
                "accountId": matrix_output[account_name]['Id'],
                "accountName": account_name
            })

    return flattened_matrix

def app_list_to_paths(app_list, app_type):
    
    response = {}

    # Convert potentially nested JSON into a python list
    while isinstance(app_list, str):
        app_list = json.loads(app_list)

    logger.debug(f"app_list: {app_list}")
    logger.debug(f"app_type: {app_type}")
    for app in app_list:
        app_path = find_application_path(app_type, app)
        if app_path:
            response[app] = str(app_path)
        else:
            logger.debug(f"Path not found for app: {app}")

    # response contains the following format:
    # {
    #     "dev-app-1": "./applications/standard/web/fooapp",
    #     "dev-app-2": "./applications/standard/web/barapp",
    # }
    return response


def find_application_path(app_type, app_name):
    base_path = Path('.')
    pattern = f'./{app_type}/**/{app_name}/main.tf'
    
    for path in base_path.glob(pattern):
        return "./" + str(path.parent)  # Return the directory containing the main.tf
    #print(f'The path for {app_name} was not found')
    return None 


def paths_to_account_names(applications_with_paths, subenv, tier, account_list):

    account_names_with_paths = {}

    # Get account name list for the provided subenvironment
    account_names_in_subenv = []
    if subenv:
        subenv = subenv.lower()
        subenv_prefix = subenv.translate(str.maketrans('', '', digits)).title()
        subenv_title = subenv.title()
        for account in account_list:
            for tag in account.get('Tags', []):
                if tag.get('Key') == 'account/sub_env' and tag.get('Value') == subenv:
                    account_names_in_subenv.append(account['Name'])
                    break  # No need to check other tags for this account

    for app in applications_with_paths:
        path = applications_with_paths[app]

        path_elements = path.split('/')

        # For common-subenv, return all accounts in the subenv
        if path_elements[1] in ["common-subenv", "applications"]:
            if not subenv:
                raise ValueError(f'Path is applications, but the subenv was not provided')
            
            if path_elements[2] == "global":
                # For each account_names_in_subenv, use that as the key and the value should be {app: path}
                for account_name in account_names_in_subenv:
                    account_names_with_paths.setdefault(account_name, {'Applications': {}})
                    account_names_with_paths[account_name]['Applications'][app] = path
            else: 
                if subenv_prefix == "Dev":
                    if path_elements[2] == "pci-internal":
                        account_env = "NPPCIDev-Internal-"    
                    elif path_elements[2] == "pci-external":
                        account_env = "NPPCIDev-External-"    
                    elif path_elements[2] == "standard":
                        account_env = "NPDev-Standard-"               
                elif subenv_prefix == "Stg":
                    if path_elements[2] == "pci-internal":
                        account_env = "NPPCIStg-Internal-"    
                    elif path_elements[2] == "pci-external":
                        account_env = "NPPCIStg-External-"    
                    elif path_elements[2] == "standard":
                        account_env = "NPStg-Standard-"  
                elif subenv_prefix == "Prd":
                    if path_elements[2] == "pci-internal":
                        account_env = "PCIPrd-Internal-"    
                    elif path_elements[2] == "pci-external":
                        account_env = "PCIPrd-External-"    
                    elif path_elements[2] == "standard":
                        account_env = "Prd-Standard-"
                else:
                    raise ValueError(f'Invalid subenv prefix: {subenv_prefix}')
                account_type = path_elements[3].title()
                if account_type == "Db":
                    account_type = "DB"
                account_name = "aws-" + account_env + subenv_title + account_type
                
                account_names_with_paths.setdefault(account_name, {'Applications': {}})
                account_names_with_paths[account_name]['Applications'][app] = path

        elif path_elements[1] == "common-tier" and path_elements[2] == "mgmt":
            if tier and tier != "null":
                if tier == "production":
                    account_name = "aws-Prd-Infrastructure-Management"
                elif tier == "non-production":
                    account_name = "aws-NP-Infrastructure-Management"
                account_names_with_paths.setdefault(account_name, {'Applications': {}})
                account_names_with_paths[account_name]['Applications'][app] = path
            else:
                raise ValueError(f'Path is common-tier, but the tier was not provided')
            
        elif path_elements[1] == "public_load_balancers":
            account_name = "aws-Prd-Infrastructure-Networking"
            
            account_names_with_paths.setdefault(account_name, {'Applications': {}})
            account_names_with_paths[account_name]['Applications'][app] = path

        else:
            raise ValueError(f'Path {path} could not be resolved to an account')

    # account_names_with_paths uses the following format
    # {
    #     "aws-NPDev-Standard-Dev01Web": {
    #         "Applications":
    #             {
    #                "dev-app-1": "./applications/standard/web/fooapp",
    #                "dev-app-2": "./applications/standard/web/barapp",
    #             }
    #     }
    # }

    return account_names_with_paths

if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument('--env', help='Provide the Control Tower environment', required=True)
    parser.add_argument('--subenv', help='Provide the Subenvironment')
    parser.add_argument('--tier', help='Provide the account tier')
    parser.add_argument('--app-list', help='Provide a list of applications in JSON, from tf-ami-deployer workflow', required=True)
    parser.add_argument('--type', help='Deploment type (Top level directory in tf-ami-deployer)', required=True)
    parser.add_argument("--debug", action="store_true", help="Enable debug logging.")

    args = parser.parse_args()
    
    # Setup Logging
    if args.debug:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.INFO)
    main(args)
