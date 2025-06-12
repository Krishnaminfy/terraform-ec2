variable "aws_region" {
    description = " region"
    type = string
    default = "ap-south-1"
}

variable "vpc_cidr" {
    description = "cidr "
    type = string
    default = "10.0.0.0/16"
}

variable "intance_type" {
    description = " intance_type"
    type = string
    default = "t2.micro"
}