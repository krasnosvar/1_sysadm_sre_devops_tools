1. Installing helm, age, sops, helm-secrets
* https://helm.sh/docs/intro/install/
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
sudo bash get_helm.sh
sudo apt install age -y
sudo ansible localhost -m apt -a deb=https://github.com/getsops/sops/releases/download/v3.7.3/sops_3.7.3_amd64.deb
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.4.2 
```

2. key generation
```
age-keygen -o key.txt
Public key: age16nlnz96egfpexmmep6vxqn3mgl4tusjwzk2pvky9w3y9setk2qxsh7e5rj


* key can be passed by file path or directly as value
export SOPS_AGE_KEY_FILE=$(pwd)/key.txt
#or
export SOPS_AGE_KEY=AGE-SECRET-KEY-1M36JVT9HNVL2VYR8SK7D4KXC7F2UU8USA64W9PC4UGLRRAZV3YMQVKKM8C
export SOPS_AGE_RECIPIENTS=age16nlnz96egfpexmmep6vxqn3mgl4tusjwzk2pvky9w3y9setk2qxsh7e5rj
```


3. encrypting file ```secrets.prod.yaml ```
```
#directly to file
helm secrets encrypt helm-secrets/.infra/secrets.prod.yaml > helm-secrets/.infra/secrets.prod.yaml_enc
```

# install comand with helm-secrets
```
helm secrets -n argocd upgrade --install \
    argocd \
    charts/argo-cd \
    -f values/argocd.yaml
```
