
variable "instance_type" {
    type = string
    description = "Instance type"
    default = "t2.small"
}

variable "ami" {
    type = string
    description = "AMI. Default to Amazon Linux"
    default = "ami-03dbf0c122cb6cf1d"
}


