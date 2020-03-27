import os

def setupIgnoredCourses():
    """
    This function sets up lists of courses to ignore for accounts that
    are set to sync all courses.
    """

    if f.checkVariables():
        variables = f.getVariables()
        if len(variables['accounts']) == 0:
            print('You need to select accounts to sync first.')
            print('')
            return
    else:
        return
    
    iCourses = variables['iCourses']
    accounts = variables['accounts']
    
    if len(accounts) == 0:
        os.system('cls' if os.name == 'nt' else 'clear')
        print('You first need to set up accounts before you can set '
              'courses to ignore.')

    

    else:
        print('There are currently no accounts set up to ignore courses.')