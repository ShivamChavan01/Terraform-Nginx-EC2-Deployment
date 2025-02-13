output "instance_public_ip" {
    description = "This output shows ec2 public ip address"
  value = aws_instance.my-nginx-server.public_ip
}

output "instance_url" {
    description = "This url acess to  theNginx server"
    value = "http://${aws_instance.my-nginx-server.public_ip}"
  
}