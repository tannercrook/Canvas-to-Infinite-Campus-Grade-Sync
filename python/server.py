from urllib.request import urlopen, URLError, HTTPError, Request, quote
import ssl
import base64
import json
import functions as f

def serverCall(urlTail, method):
    """
    All server calls go through this function.
    """
    variables = f.getVariables()
    if 'accessToken' not in variables:
        print('You are missing the accessToken in the variables.json '
              'file. Please run the setup.py script to set up this '
              'variable.'
             )
        exit(0)
    if 'canvasURL' not in variables:
        print('You are missing the canvasURL in the variables.json '
              'file. Please run the setup.py script to set up this '
              'variable.'
             )
        exit(0)
    accessToken = variables['accessToken']
    req = Request(f"{variables['canvasURL']}{urlTail}")
    req.add_header("Authorization", f"Bearer {accessToken}")
    req.get_method = lambda: method

    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS)

    try:
        response = urlopen(req, context=ctx)
        return(response)
    except ValueError as e:
        return(e)
