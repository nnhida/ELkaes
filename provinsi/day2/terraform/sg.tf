resource "aws_security_group" "techno_sg_lb" {
  name        = "techno-sg-lb"
  description = "sg for lb"
  vpc_id      = aws_vpc.techno_hida.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "techno-sg-lb"
  }
}

resource "aws_security_group" "techno_sg_apps" {
  name        = "techno-sg-apps"
  description = "sg for apps"
  vpc_id      = aws_vpc.techno_hida.id

  ingress {
    from_port   = 2000
    to_port     = 2000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "techno-sg-apps"
  }
}

