import server as s
import functions as f
import accounts as a
import os
import json


def mainMenu():
    """
    Displays the main menu of the setup script.
    """

    os.system('cls' if os.name == 'nt' else 'clear')
    print('Main Menu')
    print('1 - Set Canvas Instance URL')
    print('2 - Set District Account ID')
    print('3 - Set Canvas Access Token')
    print('4 - Select Accounts to Sync')
    print('5 - Select Terms to Sync')
    print('6 - Set Ignored Courses (If specific courses should be skipped.)')
    print('7 - Set Courses to Sync (If only select courses are synced)')
    print('8 - Set Run Path')
    print('9 - Help')
    print('10 - Exit')
    userInput = input('Select an option: ')
    userInput = userInput.strip() # Removes the trailing space from the path.
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')

    if userInput == '1':
        os.system('cls' if os.name == 'nt' else 'clear')
        setURL()
    elif userInput == '2':
        os.system('cls' if os.name == 'nt' else 'clear')
        setDistrictID()
    elif userInput == '3':
        os.system('cls' if os.name == 'nt' else 'clear')
        setAccessToken()
    elif userInput == '4':
        os.system('cls' if os.name == 'nt' else 'clear')
        setAccountsToSync()
    elif userInput == '5':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Do Something')
    elif userInput == '6':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Do Something')
    elif userInput == '7':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Do Something')
    elif userInput == '8':
        os.system('cls' if os.name == 'nt' else 'clear')
        setPath()
    elif userInput == '9':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Do Something')
    elif userInput == '10':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Goodbye!')
        exit(0)
    else:
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Invalid choice. Please input a valid choice.')
        mainMenu()


def writeJSON(variables):
    """
    Writes the variables.json file.
    """
    with open('variables.json', 'w') as jsonFile:
        json.dump(variables, jsonFile, indent=4)


def setURL():
    """
    Sets the Canvas URL variable.
    """

    print('Please enter the url for your Canvas instance. '
          'It should be complete, from the https to the .com. '
          'i.e https://yourschool.instructure.com'
         )
    userInput = input("Your url: ")
    userInput = userInput.strip()
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')
    variables = f.getVariables()
    variables['canvasURL'] = userInput
    writeJSON(variables)
    print(f'URL set to {userInput}')
    mainMenu()


def setDistrictID():
    """
    Sets the Canvas district account id variable. This is the base
    account id for your Canvas instance.
    """

    print('Please enter the district account id for the base account '
          'of your Canvas instance. It should be a number.'
         )
    userInput = input("District Account ID: ")
    userInput = userInput.strip()
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')
    variables = f.getVariables()
    variables['districtAccountID'] = userInput
    writeJSON(variables)
    print(f'District account iID set to {userInput}')
    mainMenu()


def setAccessToken():
    """
    Sets the Canvas access token.
    """

    print('Please enter the access token for Canvas. This needs to be '
          'for an admin account.'
         )
    userInput = input("District Account ID: ")
    userInput = userInput.strip()
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')
    variables = f.getVariables()
    variables['accessToken'] = userInput
    writeJSON(variables)
    print(f'Canvas access token set to {userInput}')
    mainMenu()


def setAccountsToSync():
    """
    Sets the Canvas sub accounts from which you want to sync grades.
    """


    variables = f.getVariables()
    accounts = a.getAccounts()

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
        print('')
        print('Currently Syncing Accounts')
        if len(sAccounts) > 0:
            for account in sAccounts:
                print('Account ID - Account Name')
                print(f'{account["id"]} - {account["name"]}')
        else:
            print('There are not any accounts set up to sync.')
        print('')
        setAccountsToSync()
    elif userInput == '2':
        accountIDs = []
        print('')
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
        print('')
    elif userInput == '3':
        print('')
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
        print('')

    elif userInput =='4':
        mainMenu()
    else:
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Invalid choice. Please input a valid choice.')
        setAccountsToSync()
    variables['accounts'] = sAccounts

    # print('Please enter the district account id for the base account '
    #       'of your Canvas instance. It should be a number.'
    #      )
    # userInput = input("District Account ID: ")
    # userInput = userInput.strip()
    # userInput = userInput.replace('"', "")
    # userInput = userInput.replace("'", '')
    # variables = f.getVariables()
    # variables['districtAccountID'] = userInput
    writeJSON(variables)
    setAccountsToSync()
    # print(f'District account iID set to {userInput}')
    # mainMenu()


def setPath():
    """
    Sets the run path of the script.
    """

    print('If you are running this script as a scheduled task, you '
          'need to put the full path to the script folder. i.e. '
          '/home/sync/Canvas-to-Infinite-Campus-Grade-Sync/python/'
         )
    userInput = input("Path: ")
    userInput = userInput.strip()
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')
    variables = f.getVariables()
    variables['path'] = userInput
    writeJSON(variables)
    print(f'Path set to {userInput}')
    mainMenu()

mainMenu()
