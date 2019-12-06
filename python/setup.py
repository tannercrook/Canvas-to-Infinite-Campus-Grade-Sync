import server as s
import os
import json


def mainMenu():
    """
    Displays the main menu of the setup script.
    """

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
        setURL()
    elif userInput == '2':
        setDistrictID()
    elif userInput == '3':
        setAccessToken()
    elif userInput == '4':
        print('Do Something')
    elif userInput == '5':
        print('Do Something')
    elif userInput == '6':
        print('Do Something')
    elif userInput == '7':
        print('Do Something')
    elif userInput == '8':
        setPath()
    elif userInput == '9':
        print('Do Something')
    elif userInput == '10':
        print('Goodbye!')
        exit(0)
    else:
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Invalid choice. Please input a valid choice.')
        mainMenu()


def loadJSON():
    """
    Loads the variables.json file for modification. If the file doesn't
    exist, it returns a blank dictionary.
    """
    if os.path.exists('variables.json'):
        with open('variables.json') as jsonFile:

            variables = json.loads(jsonFile.read())
            return variables
    else:
        variables = {}
        variables['path'] = ''
        return variables


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

    os.system('cls' if os.name == 'nt' else 'clear')
    print('Please enter the url for your Canvas instance. '
          'It should be complete, from the https to the .com. '
          'i.e https://yourschool.instructure.com'
         )
    userInput = input("Your url: ")
    userInput = userInput.strip()
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')
    variables = loadJSON()
    variables['canvasURL'] = userInput
    writeJSON(variables)
    print(f'URL set to {userInput}')
    mainMenu()


def setDistrictID():
    """
    Sets the Canvas district account id variable. This is the base
    account id for your Canvas instance.
    """

    os.system('cls' if os.name == 'nt' else 'clear')
    print('Please enter the district account id for the base account '
          'of your Canvas instance. It should be a number.'
         )
    userInput = input("District Account ID: ")
    userInput = userInput.strip()
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')
    variables = loadJSON()
    variables['districtAccountID'] = userInput
    writeJSON(variables)
    print(f'District account iID set to {userInput}')
    mainMenu()


def setAccessToken():
    """
    Sets the Canvas access token.
    """

    os.system('cls' if os.name == 'nt' else 'clear')
    print('Please enter the access token for Canvas. This needs to be '
          'for an admin account.'
         )
    userInput = input("District Account ID: ")
    userInput = userInput.strip()
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')
    variables = loadJSON()
    variables['accessToken'] = userInput
    writeJSON(variables)
    print(f'Canvas access token set to {userInput}')
    mainMenu()


def setPath():
    """
    Sets the run path of the script.
    """

    os.system('cls' if os.name == 'nt' else 'clear')
    print('If you are running this script as a scheduled task, you '
          'need to put the full path to the script folder. i.e. '
          '/home/sync/Canvas-to-Infinite-Campus-Grade-Sync/python/'
         )
    userInput = input("Path: ")
    userInput = userInput.strip()
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')
    variables = loadJSON()
    variables['path'] = userInput
    writeJSON(variables)
    print(f'Path set to {userInput}')
    mainMenu()

mainMenu()
