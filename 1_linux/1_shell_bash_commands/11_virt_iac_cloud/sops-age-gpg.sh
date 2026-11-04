#AGE - simple file encryption
age-keygen -o ~/.config/sops/age/keys.txt     # prints public key age1...
age -r age1PUBKEY -o secret.txt.age secret.txt
age -d -i ~/.config/sops/age/keys.txt secret.txt.age

#SOPS - encrypt only values in yaml/json/env, keys stay readable (git-friendly)
# .sops.yaml in repo root:
creation_rules:
  - path_regex: .*secrets.*\.ya?ml$
    encrypted_regex: ^(data|stringData|password|token)$
    age: age1PUBKEY1,age1PUBKEY2

sops -e -i secrets.yaml           # encrypt in place
sops -d secrets.yaml              # decrypt to stdout
sops secrets.yaml                 # edit in $EDITOR
sops updatekeys secrets.yaml      # after recipients changed in .sops.yaml
sops exec-env secrets.env 'env | grep DB_'   # run with decrypted env
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt

#GPG
gpg --full-generate-key
gpg --list-keys --keyid-format long
gpg --list-secret-keys
gpg --armor --export KEYID > pub.asc
gpg --import pub.asc
gpg -e -r user@example.com file           # encrypt for recipient
gpg -d file.gpg > file
gpg -c file                               # symmetric, password
gpg --detach-sign --armor file && gpg --verify file.asc file
gpg --edit-key KEYID                      # trust, expire, adduid
