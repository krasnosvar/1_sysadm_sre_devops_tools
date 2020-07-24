#execute local script on server through ssh
ssh root@192.168.1.1 'bash -s' < script.sh

ssh-keygen -t rsa

ssh-copy-id -i .ssh/id_rsa.pub den@192.168.43.215

#mikrotik ssh key add to routeros
scp ~/.ssh/id_rsa.pub admin@192.168.88.1:/
user ssh-keys import user=admin public-key-file=id_rsa.pub

sudo vi /etc/ssh/ssh_config
### Алиасы для быстрого подключения ###
Host userv
HostName 192.168.43.100 
User den
Port 22

#сгенерировать ключ одной командой(для скриптов), without passphrase
# -b bits
#              Specifies the number of bits in the key to create.  For RSA keys, the minimum size is 1024 bits and the default is 2048 bits.  Generally,
#              2048 bits is considered sufficient.  DSA keys must be exactly 1024 bits as specified by FIPS 186-2.  For ECDSA keys, the -b flag deter‐
#              mines the key length by selecting from one of three elliptic curve sizes: 256, 384 or 521 bits.  Attempting to use bit lengths other than
#              these three values for ECDSA keys will fail.  Ed25519 keys have a fixed length and the -b flag will be ignored.
# -t dsa | ecdsa | ed25519 | rsa
#              Specifies the type of key to create.  The possible values are “dsa”, “ecdsa”, “ed25519”, or “rsa”.
# -f filename
#              Specifies the filename of the key file.
# -N new_passphrase
#              Provides the new passphrase.            
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
