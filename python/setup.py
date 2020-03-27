import server as s
import functions as f
import accounts as a
import terms as t
import courses as c
import os
import json


def mainMenu():
    """
    Displays the main menu of the setup script.
    """

    print('Main Menu')
    print('1 - Set Canvas Instance URL')
    print('2 - Set Root Account ID')
    print('3 - Set Canvas Access Token')
    print('4 - Select Accounts to Sync')
    print('5 - Select Terms to Sync')
    print('6 - Set Ignored Courses (If specific courses should be skipped.)')
    print('7 - Set Courses to Sync (If only select courses are synced)')
    print('8 - Set Run Path')
    print('9 - Help')
    print('10 - Exit')
    userInput = input('Select an option: ')
    userInput = f.stripUserInput(userInput)

    if userInput == '1':
        os.system('cls' if os.name == 'nt' else 'clear')
        setURL()
    elif userInput == '2':
        os.system('cls' if os.name == 'nt' else 'clear')
        setRootID()
    elif userInput == '3':
        os.system('cls' if os.name == 'nt' else 'clear')
        setAccessToken()
    elif userInput == '4':
        os.system('cls' if os.name == 'nt' else 'clear')
        a.setAccountsToSync()
        mainMenu()
    elif userInput == '5':
        os.system('cls' if os.name == 'nt' else 'clear')
        t.setTermsToSync()
        mainMenu()
    elif userInput == '6':
        os.system('cls' if os.name == 'nt' else 'clear')
        c.setupIgnoredCourses()
        mainMenu()
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


def setURL():
    """
    Sets the Canvas URL variable.
    """

    print('Please enter the url for your Canvas instance. '
          'It should be complete, from the https to the .com. '
          'i.e https://yourschool.instructure.com'
         )
    userInput = input("Your url: ")
    userInput = f.stripUserInput(userInput)
    variables = f.getVariables()
    variables['canvasURL'] = userInput
    f.writeJSON(variables)
    print(f'URL set to {userInput}')
    mainMenu()


def setRootID():
    """
    Sets the Canvas root account id variable. This is the base
    account id for your Canvas instance.
    """

    print('Please enter the root account id for the base account '
          'of your Canvas instance. It should be a number.'
         )
    userInput = input("Root Account ID: ")
    userInput = f.stripUserInput(userInput)
    variables = f.getVariables()
    variables['rootAccountID'] = userInput
    f.writeJSON(variables)
    print(f'Root account ID set to {userInput}')
    mainMenu()


def setAccessToken():
    """
    Sets the Canvas access token.
    """

    print('Please enter the access token for Canvas. This needs to be '
          'for an admin account.'
         )
    userInput = input("District Account ID: ")
    userInput = f.stripUserInput(userInput)
    variables = f.getVariables()
    variables['accessToken'] = userInput
    f.writeJSON(variables)
    print(f'Canvas access token set to {userInput}')
    mainMenu()

def setPath():
    """
    Sets the run path of the script.
    """

    print('If you are running this script as a scheduled task, you '
          'need to put the full path to the script folder. i.e. '
          '/home/sync/Canvas-to-Infinite-Campus-Grade-Sync/python/'
         )
    userInput = input("Path: ")
    userInput = f.stripUserInput(userInput)
    variables = f.getVariables()
    variables['path'] = userInput
    f.writeJSON(variables)
    print(f'Path set to {userInput}')
    mainMenu()

mainMenu()