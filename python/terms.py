import server as s
import functions as f
import json
import os

def getTerms():
    """
    Retrieves all terms for a given account.
    """
    variables = f.getVariables()
    rootID = variables['rootAccountID']
    urlTail = f'/api/v1/accounts/{rootID}/terms?per_page=100'
    response = s.serverCall(urlTail, 'GET')
    terms = json.loads(response.read())
    termList = []
    for term in terms['enrollment_terms']:
        newTerm = {}
        newTerm['id'] = term['id']
        newTerm['name'] = term['name']
        termList.append(newTerm)
    
    return termList

def setTermsToSync():
    """
    Sets the Canvas terms from which you want to sync grades.
    """

    if f.checkVariables():
        variables = f.getVariables()
        if len(variables['accounts']) == 0:
            print('You need to select accounts to sync first.')
            print('')
            return
    else:
        return

    terms = getTerms()

    sTerms = variables['terms']
    sTermIDs = []
    
    for term in sTerms:
        sTermIDs.append(term['id'])

    print('Terms Menu')
    print('1 - See Currently Syncing Terms')
    print('2 - Add Term')
    print('3 - Remove Term')
    print('4 - Main Menu')
    userInput = input("Option: ")
    userInput = f.stripUserInput(userInput)

    if userInput == '1':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Currently Syncing Terms')
        if len(sTerms) > 0:
            print('TermD - Term Name')
            for term in sTerms:
                print(f'{term["id"]} - {term["name"]}')
        else:
            print('There are not any terms set up to sync.')
        print('')
        setTermsToSync()
    elif userInput == '2':
        termIDs = []
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Term ID - Term Name')
        for term in terms:
            if term['id'] in sTermIDs:
                continue
            print(f'{term["id"]} - {term["name"]}')
            termIDs.append(term['id'])
        userInput = input("Term to add: ")
        userInput = f.stripUserInput(userInput)
        if not userInput.isdigit():
            print('Invalid choice. Please input a valid choice.')
            setTermsToSync()
        if int(userInput) not in termIDs:
            print('Invalid choice. Please input a valid choice.')
            setTermsToSync()
        for term in terms:
            if term['id'] == int(userInput):
                sTerms.append(term)
        variables['terms'] = sTerms
        f.writeJSON(variables)
        print('')
        setTermsToSync()
        
    elif userInput == '3':
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Term ID - Term Name')
        for term in sTerms:
            print(f'{term["id"]} - {term["name"]}')
        userInput = input("Term to remove: ")
        userInput = f.stripUserInput(userInput)
        if not userInput.isdigit():
            print('Invalid choice. Please input a valid choice.')
            setTermsToSync()
        if int(userInput) not in sTermIDs:
            print('Invalid choice. Please input a valid choice.')
            setTermsToSync()
        for term in sTerms:
            if term['id'] == int(userInput):
                sTerms.remove(term)
        variables['terms'] = sTerms
        f.writeJSON(variables)
        print('')
        setTermsToSync()

    elif userInput =='4':
        os.system('cls' if os.name == 'nt' else 'clear')
    else:
        os.system('cls' if os.name == 'nt' else 'clear')
        print('Invalid choice. Please input a valid choice.')
        setTermsToSync()
