import server as s
import functions as f
import json


def getAccounts():
    """
    Retrieves the account IDs for all the accounts in your Canvas
    instance.
    """
    variables = f.getVariables()
    districtID = variables['districtAccountID']
    urlTail = f'/api/v1/accounts/{districtID}/sub_accounts'
    response = s.serverCall(urlTail, 'GET')
    accounts = json.loads(response.read())
    accountList = []
    for account in accounts:
        newAccount = {}
        newAccount['id'] = account['id']
        newAccount['name'] = account['name']
        accountList.append(newAccount)

    return accountList
