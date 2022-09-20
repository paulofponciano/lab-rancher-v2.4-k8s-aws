resource "aws_lb_target_group" "k8s-target-group" {
  name     = join("-", [var.project_name, "k8s-target-group"])
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_subnet.selected-private_az1.vpc_id

  health_check {
    healthy_threshold   = 3
    interval            = 30
    protocol            = "TCP"
    unhealthy_threshold = 3
  }

  tags = {
    Name      = join("-", [var.project_name, "k8s-target-group"])
    Env       = var.env
    Terraform = true
  }
}

/*resource "aws_lb_target_group_attachment" "k8s-cluster" {
  target_group_arn = aws_lb_target_group.k8s-target-group.arn
  target_id        =
  port             = 80

  depends_on = [
    aws_instance.create-ec2-k8s,
    aws_lb_target_group.k8s-target-group
  ]
}*/

resource "aws_lb" "k8s-cluster-nlb" {
  name               = join("-", [var.project_name, "k8s-nlb"])
  load_balancer_type = "network"
  internal           = false
  subnets            = [var.subnet_id_public_az1, var.subnet_id_public_az2]

  enable_cross_zone_load_balancing = false

  tags = {
    Name      = join("-", [var.project_name, "k8s-nlb"])
    Env       = var.env
    Terraform = true
  }
}

resource "aws_lb_listener" "k8s-cluster-listener" {
  load_balancer_arn = aws_lb.k8s-cluster-nlb.arn

  port     = 80
  protocol = "TCP"

  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = aws_acm_certificate.resource_name.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s-target-group.arn
  }

  depends_on = [
    aws_lb_target_group.k8s-target-group,
    aws_lb.k8s-cluster-nlb
  ]
}
