# script takes login pass from args and sends it to privatebin, url as output
# pip3 install privatebinapi


#for args
import sys
import privatebinapi

privatebin_server_url = "https://privatebin.domain.local"
username = sys.argv[1]
password = sys.argv[2]


privbin_message = ( f"{username}\n"
                    f"{password}" )

send_response = privatebinapi.send(privatebin_server_url, text=privbin_message)

print(f"{username}")
print(send_response["full_url"])
