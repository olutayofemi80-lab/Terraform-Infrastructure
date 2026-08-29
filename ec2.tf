resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = aws_subnet.public_a.id

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data                   = file("${path.module}/userdata.sh")
  user_data_replace_on_change = true

  tags = {
    Name = var.instance_name
  }
}