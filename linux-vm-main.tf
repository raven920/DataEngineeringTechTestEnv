# Define the security group for the Linux server
resource "aws_security_group" "aws-linux-sg" {
  name        = "linux-sg"
  description = "Allow incoming traffic to the Linux EC2 Instance"
  vpc_id      = aws_vpc.vpc.id
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "jupyter_password" {
  length           = 16
  special          = false
}


resource "aws_instance" "linux-server" {
  ami                         = "ami-02396cdd13e9a1257"
  instance_type               = var.linux_instance_type
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.aws-linux-sg.id]
  associate_public_ip_address = var.linux_associate_public_ip_address
  source_dest_check           = false 
  key_name                    = aws_key_pair.key_pair.key_name
  user_data_base64 = base64encode(
    "${templatefile("scripts/aws-user-data.sh", { 
          JUPYTER_PWORD   = random_password.jupyter_password.result
        }
      )
    }"
  )                   
  
  #= file("aws-user-data.sh")
  
  # root disk
  root_block_device {
    volume_size           = var.linux_root_volume_size
    volume_type           = var.linux_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
  # extra disk
  # ebs_block_device {
  #   device_name           = "/dev/xvda"
  #   volume_size           = var.linux_data_volume_size
  #   volume_type           = var.linux_data_volume_type
  #   encrypted             = true
  #   delete_on_termination = true
  # }
  
  tags = {
    Name = "linux-vm"
  }
}

# Create Elastic IP for the EC2 instance
resource "aws_eip" "linux-eip" {
  vpc  = true
  tags = {
    Name = "linux-eip"
  }
}
# Associate Elastic IP to Linux Server
resource "aws_eip_association" "linux-eip-association" {
  instance_id   = aws_instance.linux-server.id
  allocation_id = aws_eip.linux-eip.id
}