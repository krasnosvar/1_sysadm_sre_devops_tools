import json
# from collections import OrderedDict
# mydict = OrderedDict([('4', 5), ('6', 7)])
# print(json.dumps([1,2,3,mydict], separators=(',', ':')))

    
print(json.dumps({'4': 5, '6': 7}, sort_keys=True, indent=4))
