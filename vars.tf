variable "project_name" {
  default = "my-k8s-project"
}

variable "env" {
  default = "dev"
}

#For k8s cluster
variable "instance_name" {
  type = list(string)
  default = [
    "k8s-node-01",
    "k8s-node-02",
    "k8s-node-03",
  ]
}

#For rancher
variable "rancher_name" {
  default = "rancher-node"
}

#For rancher and NLB
variable "subnet_id_public_az1" {
  default = "subnet-*****************"
}

variable "subnet_id_public_az2" {
  default = "subnet-*****************"
}

#For k8s cluster
variable "subnet_id_private_az1" {
  default = "subnet-*****************"
}

variable "aws_details" {
  type = map(string)
  default = {
    region        = "us-west-2"
    instance_type = "t3.medium"
    key_name      = "k8s-kp" #keypair (.pem)
  }
}
