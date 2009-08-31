#! /bin/bash

IFACE=$(route -n | grep \^0.0.0.0 | sed -e "s/.* \([^ ]*\)$/\1/")
LOCAL=$(ifconfig $IFACE | grep "inet addr" | sed -e "s/.*addr:\([^ ]*\).*/\1/")
REMOTE=$(wget --quiet -O - http://iiska.kapsi.fi/myip.php)

echo "Local:  $LOCAL"
echo "Public: $REMOTE"