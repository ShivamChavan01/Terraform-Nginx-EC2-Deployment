resource "aws_instance" "my-nginx-server" {
    ami = "aws-r2rf3hheyjjbddj"
    instance_type = "t3.nano"
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.nginx-sp.id]
    associate_public_ip_address = true


    user_data = <<-EOF
           #!/bin/bash
           sudo yum install nginx -y
           sudo systemctl start nginx
    EOF

    tags = {
      Name= " Nginx-Ec2-Server"
    }
  
}