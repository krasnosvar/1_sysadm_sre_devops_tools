# https://docs.ansible.com/ansible/latest/vault_guide/vault.html


# environment variables to not to enter password all time needed
export ANSIBLE_VAULT_PASSWORD_FILE=/path/to/passwd/file/pass.txt
# if not one vault-password file
export ANSIBLE_VAULT_IDENTITY_LIST="project_one@/path/to/passwd/file/passProj1.txt,project_two@/path/to/passwd/file/passProj2.txt"


# DECRYPT 
# only view encrypted file
ansible-vault view /path/to/encrypted/file/encrypted.yaml
# if not all file encrypted, only some variables, show in terminal encrypted varilable:
ansible localhost -e "@/path/to/partially/encrypted/file/partially_encrypted.yaml" -m debug -a var="VAR_TO_DECRYPT"
# or same with ask pass
ansible localhost -e '@vars/file' --ask-vault-pass -m debug -a 'var=my_secret'
# decrypt file ( if entire all file encrypted ) - file will be saved as DECRYPTED automatically
ansible-vault decrypt /path/to/encrypted/file/encrypted.yaml
# 


# ENCRYPT
# encrypt string to terminal ( to copy to partially encrypted file)
ansible-vault encrypt_string --vault-id project_one@/path/to/passwd/file/passProj1 "sVug9Tt9LASH+SuEX6OR8fzItusZVnxSgNDF+SGA==" --name 'encrypted_variable'
#encrypt all file
ansible-vault encrypt --vault-id project_one@/path/to/passwd/file/passProj1 file.yaml
