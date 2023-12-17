resource "aws_instance" "web" {

    ami = "ami-0e83be366243f524a" #changeyourAMIid
    instance_type = "t2.medium"
    key_name = "ajay" #changeyourkeypair
    vpc_security_group_ids = [ aws_security_group.monitoring-sg.id ]
    user_data = templatefile("./script.sh", {})

    tags = {
        name = "monitoring-servers"
    }

  
}
resource "aws_security_group" "monitoring-sg" {
  name        = "Jenkins-sg"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 9090, 9100, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "monitoring-sg"
    }
  
}
