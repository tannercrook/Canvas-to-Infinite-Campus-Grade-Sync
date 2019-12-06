from urllib.request import urlopen, URLError, HTTPError, Request, quote
import ssl
import base64
import json

def serverCall(url, method):
    """
    All server calls go through this function.
    """
    accessToken = variables.accessToken
    req = Request(url)
    req.add_header("Authorization", f"Bearer {accessToken}")
    req.get_method = lambda: method

    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS)

    try:
        response = urlopen(req, context=ctx)
        return(response)
    except ValueError as e:
        return(e)

def jamfGetCall(urlTail):
    """
    This function handles all get calls to the JSS instance.
    """
    jssUser = variables.jssUser
    jssPass = variables.jssPass
    jssBaseURL = variables.jssBaseURL

    url = f"{jssBaseURL}{urlTail}"
    req = Request(url)
    req.get_method = lambda: "GET"
    tobase64string = f"{jssUser}:{jssPass}"
    base64str = base64.b64encode(tobase64string.encode("utf-8")).decode("utf-8")
    authheader = f"Basic {base64str}"
    req.add_header("Authorization", authheader)
    req.add_header("Accept", "application/json")

    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS)

    try:
        response = urlopen(req, context=ctx)
        return(json.loads(response.read().decode("utf-8")))
    except Exception as e:
        print(e)

def jamfEditGroupMembership(groupID, newXML):
    """
    This function is used to edit the memberships of groups.
    """
    jssUser = variables.jssUser
    jssPass = variables.jssPass
    jssBaseURL = variables.jssBaseURL

    tobase64string = '%s:%s' % (jssUser, jssPass)
    base64string = base64.b64encode(tobase64string.encode('utf-8')).decode('utf-8')

    url="{}usergroups/id/{}".format(jssBaseURL, groupID)

    req = Request(url,newXML.encode('utf-8'))
    req.add_header('Content-Type', 'text/xml')
    req.get_method = lambda: 'PUT'
    authheader = "Basic %s" % base64string
    req.add_header("Authorization", authheader)
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS)
    try:
        urlopen(req,context=ctx)
    except Exception as e:
        print("Error: Failed to update group membership.")
        print(e)

        return "Success"
