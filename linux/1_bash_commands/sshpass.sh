Чтобы попадать на сервера без ввода пароля, надо:

    установить sshpass
    apt install sshpass

    прописать в ~/.bashrc функцию

function kras() {
        sshpass -p password -v ssh -o StrictHostKeychecking=no krasnosvarov_dn@${1}
}
export -f kras

 

#объяснение переменных функции:
sshpass- приложение, надо установить
флаг "-v" - verbose(подробный) вывод, можно не включать, был сделан для отладки написания функции
StrictHostKeychecking=no при запросе ssh подключения чтобы не было ошибки и продолжалось выполнение
${1} в фигурных кавычках- чтобы аргумент применялся без пробела, вида user@server

такие же функции можно прописать для toor и local

---------------------------------------------------------------------------------------------

function loc() {

        sshpass -p parol ssh -o StrictHostKeychecking=no local@${1}

}

export -f loc

 

function toor() {
        sshpass -p parol ssh -o StrictHostKeychecking=no toor@${1}
}
export -f toor

 ---------------------------------------------------------------------------------------------

Примечание: нельзя называть функцию local, т.к. эта команда в bash используется для указания локальных переменных.
Использование функции с именем local поломает терминал. Отменить функцию можно командой unset local

#чтобы применить функцию как алиас, выполнить команду в bash:
source .bashrc

 #теперь можно заходить на сервера простой командой вида user server, пример для сервера rundeck:
loc rundeck

или

toor 10.5.46.30

-------------------------------------------------------------------------------------------------------------------------------------------------

#Выполнить команду через sshpass на удаленном сервере сразу в sudo:

sshpass -p PASSWORD -v ssh -o StrictHostKeychecking=no local@rundeck 'echo PASSWORD | sudo -S -s /bin/bash -c "whoami; ping localhost -c 4"'

#если ругается на символы "!" и т.п., их надо экранировать "\", например PASSWORD! надо записывать вида PASSWORD\!
