provider "aws" {
  region  = "ap-south-1"
}


resource "aws_vpc" "day2-krishna-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}


resource "aws_subnet" "day2-krishna-public-subnet" {
  vpc_id                  = aws_vpc.day2-krishna-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "public-subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "day2-krishna-igw" {
  vpc_id = aws_vpc.day2-krishna-vpc.id

  tags = {
    Name = "main-igw"
  }
}

# Route table for public subnet
resource "aws_route_table" "day2-krishna-public_rt" {
  vpc_id = aws_vpc.day2-krishna-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.day2-krishna-igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate route table with public subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.day2-krishna-public-subnet.id
  route_table_id = aws_route_table.day2-krishna-public_rt.id
}

# Create a security group
resource "aws_security_group" "day2-krishna-web_sg" {
  name        = "day2-krishna-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.day2-krishna-vpc.id

  # Allow SSH from your IP only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.194.147.50/32"]  
  }

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}

# Launch EC2 instance
resource "aws_instance" "day2-krishna-web_server" {
  ami           = "ami-0b09627181c8d5778"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.day2-krishna-public-subnet.id
  vpc_security_group_ids = [aws_security_group.day2-krishna-web_sg.id]
  associate_public_ip_address = true
  
    user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
            EOF

  tags = {
    Name = "WebServer"
  }
}
