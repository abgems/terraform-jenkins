resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
  
}
resource "aws_subnet" "mysubnet" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
  
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
  
}
resource "aws_route_table" "myrt" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }  
  
}
resource "aws_route_table_association" "rtas" {
    subnet_id = aws_subnet.mysubnet.id
    route_table_id = aws_route_table.myrt.id
  
}
resource "aws_security_group" "mysg" {
    vpc_id = aws_vpc.myvpc.id

    ingress {
        description = "SSH Port open"
        to_port = 22
        from_port = 22
        protocol = "tcp"
        cidr_blocks =["0.0.0.0/0"]
    }

     ingress {
        description = "HTTP Port open"
        to_port = 80
        from_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Jenkins Port open"
        to_port = 8080
        from_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "Outbound rules"
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "my-sg"
    }
  
}
resource "aws_ebs_volume" "myvolume" {
    size = 20
    availability_zone = "ap-south-1a"
  
}
resource "aws_instance" "myjenkins" {
  ami                    = "ami-0dee22c13ea7a9a67"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.mysubnet.id
  vpc_security_group_ids = [aws_security_group.mysg.id]
  user_data = base64encode(file("userdata.sh"))
}

output "myIp" {
    value = aws_instance.myjenkins.public_ip
  
}
