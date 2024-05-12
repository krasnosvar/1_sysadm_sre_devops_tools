-----------------------------------------------------------------
#terraform
den@den-UX310UQK:06_k8s$ cat /etc/bash_completion.d/terraform 
#!/usr/bin/env bash

# Don't handle completion if it's already managed
complete -p terraform &>/dev/null && return

# Terraform completes itself
complete -C terraform terraform
------------------------------------------------------------------

#terraform and kubectl
tail ~/.bashrc 

complete -C /usr/bin/terraform terraform
alias k=kubectl
complete -F __start_kubectl k
source <(kubectl completion bash)
------------------------------------------------------------------
#Docker autocompletion
#https://docs.docker.com/compose/completion/
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.27.4/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
