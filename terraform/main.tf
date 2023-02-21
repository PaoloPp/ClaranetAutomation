resource "aws_vpc" "vpc1"{
 cidr_cidr_block = "10.0.0.0/16"   
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc1.id

    
}