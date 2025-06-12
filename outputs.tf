output "instance_public_ip" {
    description = "this is the public ip address of ec2 instance"
    value = aws_instance.day2-krishna-web_server.public_ip
}

output "instance_private_ip" {
    description = "this is the private ip address of ec2 instance"
    value = aws_instance.day2-krishna-web_server.private_ip
}

