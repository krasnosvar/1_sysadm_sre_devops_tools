variable "token" {}
#aws keys
# variable "access-key" {}
# variable "secret-key" {}
# variable "awszoneid" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.token
}
#  Main ssh key
resource "hcloud_ssh_key" "kras_pub_key" {
  name       = "kras_ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "hcloud_server" "ex15-dev-node" {
  name        = "ex15-dev-node"
  image       = "ubuntu-18.04"
  server_type = "cx11"
    labels = {
      module = "dev_ex_15"
      email = "krasnosvar_gmail.com"
    }        
  ssh_keys    = [hcloud_ssh_key.kras_pub_key.name]
   #Copies the rebrain ssh key to remote droplet
    provisioner "file" {
      connection {
        type     = "ssh"
        private_key = file("~/.ssh/id_rsa")
        user     = "root"
        timeout  = "2m"
        host     = hcloud_server.ex15-dev-node.ipv4_address
    }
    source      = "/home/den/git_projects/rebrain_practikum/3_development/15_dev_elixir/keys/rebrain_ssh.pub"
    destination = "/etc/ssh/rebrain_ssh.pub"
      
  }
}

# provider "aws" {
#   region     = "us-west-2"
#   access_key = var.access-key
#   secret_key = var.secret-key
# }


# resource "aws_route53_record" "www" {
#   zone_id = var.awszoneid
#   name    = "krasnosvar-dev-ex16.devops.rebrain.srwx.net"
#   type    = "A"
#   ttl     = "300"
#   records = [digitalocean_droplet.ex9dev.ipv4_address]
# }

###############################
# resource "null_resource" "example1" {
#   #count = length(var.devs) 
#   provisioner "local-exec" {
#     command = "echo '[vscale_scalet]\n${digitalocean_droplet.ex9dev.ipv4_address}' > /home/den/git_projects/rebrain_practikum/2_operations/ansible/ex2_ansible/hosts"
#   }
#   provisioner "local-exec" {
#     command = "ansible-playbook -u root -i /home/den/git_projects/rebrain_practikum/2_operations/ansible/ex2_ansible/hosts --private-key ~/.ssh/id_rsa.pub ex2_playbook.yml --vault-password-file keys/vault_pass.txt" 
#   }  
# }


# Display the IP address
output "public_ip4" {
  value = hcloud_server.ex15-dev-node.ipv4_address
}


# output "FDQN" {
#   value = aws_route53_record.www.*.name
# }

#check syntax
#terraform plan -var-file="keys/do_token.tfvars"

#terraform apply -var-file="/home/den/git_projects/rebrain_practikum/2terraform/ex5_terraform/keys/do_token.tfvars"

#aws route53 list-hosted-zones-by-name --dns-name devops.rebrain.srwx.net
