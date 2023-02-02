//NAMEs
variable "env" {
    default = "env"
}

//CIDRs
variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "subnets" {
    default = 1
}

//RULEs
variable "ingress" {
    type = list
    default = [22]
}

variable "egress" {
    type = list
    default = [0]
}

//IDs
//variable "vpc_id" {}

variable "subnets_cidr" {
    type =list(string)
    default =["10.0.1.0/24","10.0.2.0/24"]
    
}