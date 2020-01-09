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
