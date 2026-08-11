To access servers without entering password, you need to:

    install sshpass
    apt install sshpass

    write function in ~/.bashrc

function kras() {
        sshpass -p password -v ssh -o StrictHostKeychecking=no krasnosvarov_dn@${1}
}
export -f kras

 

#explanation of function variables:
sshpass- application, need to install
flag "-v" - verbose(detailed) output, can be disabled, was made for debugging function writing
StrictHostKeychecking=no when ssh connection request so there's no error and execution continues
${1} in curly quotes- so argument is applied without space, like user@server

similar functions can be written for toor and local

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

Note: cannot name function local, because this command in bash is used for specifying local variables.
Using function with name local will break terminal. Function can be cancelled with command unset local

#to apply function as alias, execute command in bash:
source .bashrc

 #now you can access servers with simple command like user server, example for rundeck server:
loc rundeck

or

toor 10.5.46.30

-------------------------------------------------------------------------------------------------------------------------------------------------

#Execute command via sshpass on remote server immediately in sudo:

sshpass -p PASSWORD -v ssh -o StrictHostKeychecking=no local@rundeck 'echo PASSWORD | sudo -S -s /bin/bash -c "whoami; ping localhost -c 4"'

#if it complains about symbols "!" etc., they need to be escaped "\", for example PASSWORD! should be written as PASSWORD\!
