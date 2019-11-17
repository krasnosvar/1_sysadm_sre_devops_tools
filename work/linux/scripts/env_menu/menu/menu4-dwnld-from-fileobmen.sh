#!/bin/bash
echo "Download from FILEOBMEN.corp.domain.ru"
echo "Use it in directory you need to download file"
echo -n "Paste download link from fileobmen
(link format matters nothing. 
You can paste full link 
https://fileobmen.corp.domain.ru/dfa638ebb8c0698b7fc3083c04ea4aec, 
or just dfa638ebb8c0698b7fc3083c04ea4aec)
:> "
read fileobmen_link
python $KRAS_ENV_PATH/menu/python-menu-scripts/menu4-dwnld-fr-fileobmen.py $fileobmen_link
