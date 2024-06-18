#!/bin/sh

set -e
set -x

GORGONE_USR=$(grep username /etc/centreon-gorgone/config.d/31-centreon-api.yaml | cut -d\" -f2| head -n 1)
GORGONE_PWD=$(grep password /etc/centreon-gorgone/config.d/31-centreon-api.yaml | cut -d\" -f2 | head -n 1)

API_OUTPUT=$(curl --location 'http://apache/centreon/api/latest/login' --header 'Content-Type: application/json' --header 'Accept: application/json'  --data '{"security": {"credentials": {"login": "'"$GORGONE_USR"'","password": "'"$GORGONE_PWD"'"}}}')
API_CODE=$(echo $API_OUTPUT | jq -r '.code')

if [ "$API_CODE" != "null" ]; then
    echo "Error: API login failed code: $API_CODE"
    exit 1
else
    echo "API login success"
    API_TOKEN=$(echo $API_OUTPUT | jq -r '.security.token')
    curl --request POST 'http://apache/centreon/api/latest/platform/updates' --header 'Accept: application/json' --header "X-AUTH-TOKEN: $API_TOKEN" --data '{"components": [{"name": "centreon-web"
}]}'
fi
