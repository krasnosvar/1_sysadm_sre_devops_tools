variable "token" {}
#aws keys
variable "access-key" {}
variable "secret-key" {}
variable "awszoneid" {}


# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.token
}

resource "digitalocean_ssh_key" "my_own_ex3_key" {
  name       = "my_pub_ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_tag" "module" {
  name = "dev_ex16"
}
resource "digitalocean_tag" "email" {
  name = "krasnosvar_gmail_com"
}

# Create a new Droplet using the SSH key
resource "digitalocean_droplet" "ex9dev" {
  image    = "ubuntu-18-04-x64"
  name     = "ex9dev"
  region   = "fra1"
  tags   = [digitalocean_tag.module.name, digitalocean_tag.email.name]
  #tags   = [data.digitalocean_tag.email.name]
  size     = "s-1vcpu-2gb" #Size slugs are human-readable strings used to specify the type of Droplet in certain API requests
  ssh_keys = [digitalocean_ssh_key.my_own_ex3_key.fingerprint]
   
   #Copies the rebrain ssh key to remote droplet
    provisioner "file" {
      connection {
        type     = "ssh"
        private_key = file("~/.ssh/id_rsa")
        user     = "root"
        timeout  = "2m"
        host     = digitalocean_droplet.ex9dev.ipv4_address
    }
    source      = "/home/den/git_projects/rebrain_practikum/2_operations/terraform/ex2_terraform/keys/rebrain_ssh.pub"
    destination = "/etc/ssh/rebrain_ssh.pub"
      
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = var.access-key
  secret_key = var.secret-key
}


resource "aws_route53_record" "www" {
  zone_id = var.awszoneid
  name    = "krasnosvar-dev-ex16.devops.rebrain.srwx.net"
  type    = "A"
  ttl     = "300"
  records = [digitalocean_droplet.ex9dev.ipv4_address]
}

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
output "ipv4_address" {
  value = digitalocean_droplet.ex9dev.ipv4_address
}


output "FDQN" {
  value = aws_route53_record.www.*.name
}

#check syntax
#terraform plan -var-file="keys/do_token.tfvars"

#terraform apply -var-file="/home/den/git_projects/rebrain_practikum/2terraform/ex5_terraform/keys/do_token.tfvars"

#aws route53 list-hosted-zones-by-name --dns-name devops.rebrain.srwx.net
