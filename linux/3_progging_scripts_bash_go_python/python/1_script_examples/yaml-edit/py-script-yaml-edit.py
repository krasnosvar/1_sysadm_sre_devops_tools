# pip3 install pyyaml
import yaml
import sys
# from collections import OrderedDict

file_path = 'config_one.yml'

with open(file_path, "r") as first_file:
    vars_data = yaml.safe_load(first_file)
    # print(type(vars_data))

#vars
new_user = sys.argv[1]
groups_list_to_add = sys.argv[2].split(',')

# fill users list to check if exists
usr_list_on_vars_file = []
for i in vars_data["99_users"]:
    usr_list_on_vars_file.append(i["0_login"]) 

# append function (rewrites all file with new vars_data)
def append_to_yaml(file_path, vars_data_to_append):
    with open(file_path, 'w+') as file:
        yaml_text = yaml.dump(vars_data_to_append)
        file.write(yaml_text)

list_exist =[]
# for usr in usr_list_on_vars_file, add only groups:
if new_user in usr_list_on_vars_file and len(sys.argv) > 2:
    print(f"user: {new_user}, already in vars file, add groups")
    for i in vars_data["99_users"]:
        if i['0_login'] == new_user:
            print(i['0_login'])
            list_exist = i["2_group"]
            i["2_group"] = list(set(list_exist + groups_list_to_add))
            #add groups to "vars_data" variable to rewrite file
            append_to_yaml(file_path, vars_data)
# create new user and groups
elif new_user not in usr_list_on_vars_file and len(sys.argv) > 2:
    print(f"NOT present, creating USER {new_user}")
    #add new user to "vars_data" variable to rewrite file
    vars_data["99_users"].append({'0_login': new_user, '1_pass': new_user, '2_group': groups_list_to_add})
    append_to_yaml(file_path, vars_data)
