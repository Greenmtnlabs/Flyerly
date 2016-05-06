#you can find keys from: https://dashboard.parse.com/apps/flyerlytest/settings/keys
APPLICATION_ID="EnterKeyHere"
REST_API_KEY="EnterKeyHere"
#-H "X-Parse-REST-API-Key: ${REST_API_KEY}" \
# REST API, command line
curl -X POST \
 -H "X-Parse-Application-Id: ${APPLICATION_ID}" \
 -H "X-Parse-Master-Key: EnterKeyHere" \
 -H "Content-Type: application/json" \
 -d '{}' \
 https://api.parse.com/1/functions/appNameNotExistCount

 #hit "bash appNameNotExistCount.sh" in terminal