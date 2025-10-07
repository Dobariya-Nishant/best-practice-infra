resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.this.key_name
  security_groups             = [aws_security_group.this.id]
  associate_public_ip_address = true

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.ebs_size
    volume_type           = var.ebs_type
    delete_on_termination = true
    encrypted             = true
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user
  EOF

  tags = {
    Name = "${var.name}-ec2-${var.environment}"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}-ec2-sg-${var.environment}"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.enable_public_ssh == true ? [1] : []
    content {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = var.enable_ssh_from_current_ip == true ? [1] : []
    content {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [data.http.my_ip.response_body]
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ec2-sg-${var.environment}"
  }
}

# ========
# Key Pair
# ========
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.name}-ec2-key-${var.environment}"
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "this" {
  filename        = "${path.root}/keys/${aws_key_pair.this.key_name}.pem"
  content         = tls_private_key.this.private_key_openssh
  file_permission = "0600"
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# ===========================================================
# 🔍 Fetch public IP of current machine (used for SSH access)
# ===========================================================
data "http" "my_ip" {
  url = "https://api.ipify.org"
}
