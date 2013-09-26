var AGS_objectId; // the SWF object id

// called from ArcGIS API for Flex
function AGS_oAuthSignIn(portalURL, appId, expiration, locale, objectId)
{
    var path = location.pathname;
    var idx = path.lastIndexOf("/");
    var redirectURI = location.protocol + "//" + location.host
        + path.substring(0, idx) + "/oauth-callback.html";
    var oAuthURL = portalURL + "/sharing/oauth2/authorize?response_type=token"
        + "&client_id=" + encodeURIComponent(appId)
        + "&redirect_uri=" + encodeURIComponent(redirectURI)
        + "&expiration=" + expiration;
    if (locale)
    {
        oAuthURL += "&locale=" + locale;
    }

    var oAuthWin = window.open(oAuthURL, "AGSFlexOAuth", "height=480,width=800,location,resizable,scrollbars,status");
    oAuthWin.focus();

    AGS_objectId = objectId; // save for use in AGS_setLocationHash

    return true;
}

// called from oauth-callback.html
function AGS_setLocationHash(hash)
{
    hash = hash.substring(1); // remove leading #

    // call back into ArcGIS API for Flex
    var app = swfobject.getObjectById(AGS_objectId);
    app.setOAuthParameters(hash);
}
