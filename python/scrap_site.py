#http://theautomatic.net/2017/09/19/robobrowser-automating-online-forms/
#sudo pip3 install robobrowser
#sudo pip3 install pandas
#
from robobrowser import RoboBrowser
import pandas as pd
from sys import argv
testovoe_virazhen = argv[1]

def interface_test_ex12(testovoe_virazhen):
    '''Create RoboBrowser object
       This will act similarly to a typical web browser'''
    browser = RoboBrowser(parser='html.parser', history=True)
    #browser = RoboBrowser(history=True)
    
    
    browser.open('http://localhost:8000/')
    forms = browser.get_forms()
    form = forms[0]
    #"operation" - name of form from "html" output
    '''den@den-UX310UQK:qa-system$ curl -s localhost:8000/
        <form action="/calc" method="post">
            <input type="text" name="operation" />
            <input type="submit" value="Посчитать" />
        </form>
    '''
    form['operation'] = testovoe_virazhen
    
    
    '''Submit form'''
    browser.submit_form(form)
    html = str(browser.parsed)
    return html

print(interface_test_ex12(testovoe_virazhen))
# print(interface_test_ex12('2,*,3'))
# print(interface_test_ex12('2,+,3'))
# print(interface_test_ex12('3,-,3'))
# print(interface_test_ex12('2,/,3'))
# print(interface_test_ex12('2,**,3'))
