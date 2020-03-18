import server as s
import functions as f
import json
import os


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

def setAccountsToSync():
    """
    Sets the Canvas sub accounts from which you want to sync grades.
    """

    variables = f.getVariables()
    accounts = getAccounts()

    if 'accounts' in variables:
        sAccounts = variables['accounts']
    else:
        sAccounts = []
    sAccountIDs = []
    for account in sAccounts:
        sAccountIDs.append(account['id'])

    print('Accounts Menu')
    print('1 - See Currently Syncing Accounts')
    print('2 - Add Account')
    print('3 - Remove Account')
    print('4 - Main Menu')
    userInput = input("Option: ")
    userInput = userInput.strip()
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')

    if userInput == '1':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Currently Syncing Accounts')
        if len(sAccounts) > 0:
            print('Account ID - Account Name')
            for account in sAccounts:
                print(f'{account["id"]} - {account["name"]}')
        else:
            print('There are not any accounts set up to sync.')
        print('')
        setAccountsToSync()
    elif userInput == '2':
        accountIDs = []
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Account ID - Account Name')
        for account in accounts:
            if account['id'] in sAccountIDs:
                continue
            print(f'{account["id"]} - {account["name"]}')
            accountIDs.append(account['id'])
        userInput = input("Account to add: ")
        userInput = userInput.strip()
        userInput = userInput.replace('"', "")
        userInput = userInput.replace("'", '')
        if not userInput.isdigit():
            print('Invalid choice. Please input a valid choice.')
            setAccountsToSync()
        if int(userInput) not in accountIDs:
            print('Invalid choice. Please input a valid choice.')
            setAccountsToSync()
        for account in accounts:
            if account['id'] == int(userInput):
                sAccounts.append(account)
        variables['accounts'] = sAccounts
        f.writeJSON(variables)
        print('')
        setAccountsToSync()
        
    elif userInput == '3':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Account ID - Account Name')
        for account in sAccounts:
            print(f'{account["id"]} - {account["name"]}')
        userInput = input("Account to remove: ")
        userInput = userInput.strip()
        userInput = userInput.replace('"', "")
        userInput = userInput.replace("'", '')
        if not userInput.isdigit():
            print('Invalid choice. Please input a valid choice.')
            setAccountsToSync()
        if int(userInput) not in sAccountIDs:
            print('Invalid choice. Please input a valid choice.')
            setAccountsToSync()
        for account in sAccounts:
            if account['id'] == int(userInput):
                sAccounts.remove(account)
        variables['accounts'] = sAccounts
        f.writeJSON(variables)
        print('')
        setAccountsToSync()

    elif userInput =='4':
        os.system('cls' if os.name == 'nt' else 'clear')
    else:
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Invalid choice. Please input a valid choice.')
        setAccountsToSync()
