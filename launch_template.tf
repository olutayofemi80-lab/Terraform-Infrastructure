resource "aws_launch_template" "app" {
  name_prefix   = "terraform-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  key_name = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash

    apt update -y
    apt install docker.io -y

    systemctl start docker
    systemctl enable docker

    usermod -aG docker ubuntu
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraform-asg-instance"
    }
  }
}