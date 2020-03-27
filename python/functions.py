import json
import os

def stripUserInput(userInput):
    """
    Stripts the user input of extra characters.
    """

    userInput = userInput.strip() # Removes the trailing space from the path.
    userInput = userInput.replace('"', "")
    userInput = userInput.replace("'", '')

    return userInput


def checkVariables():
    """
    Check to make sure the basic information needed is stored before
    working on future setup.
    """

    variables = getVariables()
    if variables['canvasURL'] == '':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('You need to set up a Canvas url first.')
        print('')
        return False
    elif variables['accessToken'] == '':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('You need to set up an access token first.')
        print('')
        return False
    elif variables['rootAccountID'] == '':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('You need to set up a root account id first.')
        print('')
        return False
    else:
        return True

def getVariables():
    """
    Retrieves the variables.json file or creates one if it is not present.
    """
    if os.path.exists('variables.json'):
        with open('variables.json') as jsonFile:

            variables = json.loads(jsonFile.read())
            return variables
    else:
        variables = {}
        variables['accounts'] = []
        variables['canvasURL'] = ''
        variables['rootAccountID'] = ''
        variables['accessToken'] = ''
        variables['path'] = ''
        variables['terms'] = []
        variables['iCourses'] = []
        variables['sCourses'] = []
        return variables

def writeJSON(variables):
    """
    Writes the variables.json file.
    """
    with open('variables.json', 'w') as jsonFile:
        json.dump(variables, jsonFile, indent=4)