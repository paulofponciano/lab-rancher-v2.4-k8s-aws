output "instance_id" {
  value = values(aws_instance.create-ec2-k8s)[*].id
}
