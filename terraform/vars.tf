variable "amis" {
    default = {
        "us-east-1-ubuntu18" = "ami-0747bdcabd34c712a"
    }
}

variable "instance_type" {
    default = {
        "micro" = "t2.micro"
    }
}