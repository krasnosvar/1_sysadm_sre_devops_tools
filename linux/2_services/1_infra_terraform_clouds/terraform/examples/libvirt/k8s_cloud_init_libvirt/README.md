# Terraform script to create k8s cluster 

1. Replace only 
```
# variables that can be overriden
variable "k8s-master-hostnam" {
  type    = list(string)
  default = ["m1"]
  # default = ["m1","m2","m3"]
}

variable "k8s-worker-hostn" {
  type    = list(string)
  default = ["w1","w2"]
  # default = [ "trst-srv" ]
}
```

