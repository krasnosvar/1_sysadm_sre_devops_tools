#### Python script example to edit YAML-file

1. Script adds variables to nested variable ```99_users``` ( named with digits for proper order)
* first ARG- user login, secong ARG - groups to add  ( password, for simplicity, adds as login)

```
python3 py-script-yaml-edit.py user22 gr1,gr2,gr3,gr4
```

2. Need to install ```pip3 install pyyaml```
