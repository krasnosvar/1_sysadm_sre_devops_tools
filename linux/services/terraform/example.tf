#add gitlab-project
variable "rebrain_token" {
    type = string
}
variable "deploy_key" {
    type = string
}


provider "gitlab" {
    token = var.rebrain_token
    base_url = "https://gitlab.rebrainme.com/api/v4/"
}

# Add a project owned by the user
resource "gitlab_project" "sample_project" {
    name = "example1"
}


# Add a deploy key to the project
resource "gitlab_deploy_key" "sample_deploy_key" {
    project = gitlab_project.sample_project.id
    title = "terraform_example"
    key = var.deploy_key
    can_push = "true"
}
