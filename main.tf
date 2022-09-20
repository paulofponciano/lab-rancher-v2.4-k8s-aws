provider "aws" {
  region = lookup(var.aws_details, "region")
}

data "aws_subnet" "selected-public_az1" {
  id = var.subnet_id_public_az1
}

data "aws_subnet" "selected-public_az2" {
  id = var.subnet_id_public_az2
}

data "aws_subnet" "selected-private_az1" {
  id = var.subnet_id_private_az1
}

resource "aws_eip" "eip-rancher" {
  vpc      = true
  instance = aws_instance.create-ec2-rancher.id

  tags = {
    Name      = join("-", [var.project_name, "eip-rancher"])
    Env       = var.env
    Terraform = true
  }
}

#RANCHER NODE
resource "aws_instance" "create-ec2-rancher" {
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = lookup(var.aws_details, "instance_type")
  vpc_security_group_ids = [aws_security_group.rancher-sg.id, aws_security_group.default-sg.id]
  subnet_id              = var.subnet_id_public_az1
  key_name               = lookup(var.aws_details, "key_name")
  user_data = templatefile("init-rancher.tpl",
    {

    }
  )

  root_block_device {
    volume_size           = "30"
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name      = var.rancher_name
      Env       = var.env
      Terraform = true
    }
  }

  tags = {
    Terraform = true
    Name      = var.rancher_name
    Env       = var.env
  }
}

#K8S CLUSTER NODES
resource "aws_instance" "create-ec2-k8s" {
  for_each = toset(var.instance_name)
  #count                  = (var.instance_name)
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = lookup(var.aws_details, "instance_type")
  vpc_security_group_ids = [aws_security_group.cluster-sg.id, aws_security_group.default-sg.id]
  subnet_id              = var.subnet_id_private_az1
  key_name               = lookup(var.aws_details, "key_name")
  user_data = templatefile("init.tpl",
    {

    }
  )

  root_block_device {
    volume_size           = "30"
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name      = each.key
      Env       = var.env
      Terraform = true
    }
  }

  tags = {
    Terraform = true
    Name      = each.key
    Env       = var.env
  }
}
