#https://docs.python-guide.org/scenarios/scrape/
#sudo pip3 install lxml
from lxml import html
import requests
#Next we will use requests.get to retrieve the web page with our data, parse it using the html module, and save the results in tree:

page = requests.get('http://localhost:8000')
tree = html.fromstring(page.content)
print((page.content))

#fill forms
http://theautomatic.net/2017/09/19/robobrowser-automating-online-forms/
