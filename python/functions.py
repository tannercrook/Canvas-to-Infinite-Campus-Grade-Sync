import json
import os

def getVariables():
    """
    Retrieves the variables.json file.
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