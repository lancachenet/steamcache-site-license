#!/bin/sh

if [ -z "$STEAM_GUARD" ] && [ -n "$STEAM_AUTHCODE_URL" ]; then
    echo "Fetching Steam Guard Auth Code"
    STEAM_GUARD="`wget -qO- $STEAM_AUTHCODE_URL/index.php/code/$STEAM_USERNAME`"
    echo "Auth Code: $STEAM_GUARD"
fi
/opt/steamcmd/steamcmd.sh -sitelicense +login $STEAM_USERNAME $STEAM_PASSWORD $STEAM_GUARD