#fetch Jira Transitions IDs(for integration with gitlab)
curl -k  -u user:password_or_api_token -X GET -H "Content-Type: application/json"    https://jira.domain.ru/rest/api/2/issue/CIMIT-1622/transitions| jq "." > jira.txt
