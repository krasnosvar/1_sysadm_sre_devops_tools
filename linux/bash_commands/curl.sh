#use curl without proxy
curl  --noproxy "*"
#POST as JSON
curl -H "Content-Type: application/json" \
  -X POST \
  --data '{"username":"xyz","password":"xyz"}' \
  http://localhost:3000/api/login
