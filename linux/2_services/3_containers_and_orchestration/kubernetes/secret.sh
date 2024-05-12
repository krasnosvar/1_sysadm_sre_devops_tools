# create secret with base64
cat <<EOF >> operator-secrets.yaml
apiVersion: v1 
kind: Secret 
metadata:
  name: vault-secrets-operator 
  namespace: vault-operator 
type: Opaque 
data:
  VAULT_TOKEN: $(echo -n s.W4ndAJbuoDMsoLDZyVBG18F2 |  base64)
EOF
