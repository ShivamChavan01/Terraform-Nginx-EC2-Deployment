#create a VPC
resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
      Name = "my-vpc"
    }
  
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my-vpc.id 
    cidr_block = "10.0.1.0/24"

    tags = {
      Name = "Private_subnet"
    }
  
}

resource "aws_subnet" "public_subnet" {
    cidr_block = "10.0.2.0/24"
    vpc_id = aws_vpc.my-vpc.id

    tags = {
      Name= "Public_Subnet"
    }
  
}
resource "aws_internet_gateway" "my-igw" {
   
    vpc_id = aws_vpc.my-vpc.id
    
    tags = {
      Name = "my-igw"
    }
  
}

resource "aws_route_table" "my-rt" {
    vpc_id = aws_vpc.my-vpc.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw.id
    }

    tags = {
      Name= "My  Routing Table"
    }
  
}

resource "aws_route_table_association" "public_sub" {
    route_table_id = aws_route_table.my-rt.id
    subnet_id = aws_subnet.public_subnet.id
  
}