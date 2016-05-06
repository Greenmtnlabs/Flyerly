APPLICATION_ID="rrU7ilSR4TZNQD9xlDtH8wFoQNK4st5AaITq6Fan"
REST_API_KEY="CUXUQEZ7O9Nu4FGFiNxQdvHcxE9VAi2lWNi3Y2V5"
#-H "X-Parse-REST-API-Key: ${REST_API_KEY}" \
# REST API, command line
curl -X POST \
 -H "X-Parse-Application-Id: ${APPLICATION_ID}" \
 -H "X-Parse-Master-Key: xKx13OCFY1mSUOALjoPTMsIfGbRSAD12JlrdOFpY" \
 -H "Content-Type: application/json" \
 -d '{}' \
 https://api.parse.com/1/functions/addAppNameInOldUsers2

 #hit "bash runParseFunctionFromTerminal.sh" in terminal

 