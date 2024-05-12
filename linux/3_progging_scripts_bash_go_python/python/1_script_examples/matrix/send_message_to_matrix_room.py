
#!/bin/python3
#script for sending messages to Matrix chat room
#message example:
# Дежурный: ['Сидоров М.Е.']
# Список по порядку: 
# ["Иванов Г.Т.", "Петров Н.Н.", "Красносваров Д.Н.", "Сидоров М.Е."]

#msgtype=m.text
homeserver="im.domain.ru"
#homeserver="10.8.100.18"
room_id="ROOMID:im.domain.ru"
#token, fetched by command
#curl -XPOST -d '{"type":"m.login.password", "user":"krasnosvarov_dn", "password":""}' "https://im.domain.ru/_matrix/client/r0/login"
accesstoken=""

#curl -XPOST -d '{"msgtype":"m.text", "body":"hello"}' "https://localhost:8448/_matrix/client/r0/rooms/%21asfLdzZWu:localhost/send/m.room.message?access_token=YOUR_ACCESS_TOKEN"
#curl --noproxy "*" --insecure -XPOST -d "$( jq -Rsc --arg msgtype "$msgtype" '{$msgtype, body:.}')" "https://$homeserver/_matrix/client/r0/rooms/$room/send/m.room.message?access_token=$accesstoken"

#for post request
import requests
#for convert to json
import json
#fetch week-numbers
from datetime import date
import datetime
import calendar

weekNumber = date.today().isocalendar()[1]
adminOnDutyList = ["Иванов Г.Т.", "Петров Н.Н.", "Красносваров Д.Н.", "Сидоров М.Е."]

weekCountList = list(map(lambda x:x+1, range(1,53)))
print(weekCountList)
Rasp = list({x: adminOnDutyList[x % len(adminOnDutyList)]} for x in weekCountList)

url = f"https://{homeserver}/_matrix/client/r0/rooms/{room_id}/send/m.room.message?access_token={accesstoken}"

messageBody = f"""Дежурный: {list(Rasp[weekNumber].values())}
Список по порядку: 
{adminOnDutyList}"""

messageJsonFormat = {
                    "msgtype":"m.text",
                    "body": str(messageBody)
                    }

send_message = requests.post(url, json = messageJsonFormat)
print(send_message.text)
#print(messageBody)
