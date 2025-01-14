resource "aws_ebs_volume" "minecraft_volume" {
  availability_zone = "eu-central-1a" # Match your instance's AZ
  size              = 10           # 10GB storage
}

resource "aws_instance" "minecraft_instance" {
  ami           = "ami-08c40ec9ead489470" # Amazon Linux 2 AMI
  instance_type = "t4g.medium"
  security_groups = [aws_security_group.minecraft_sg.name]
  key_name      = var.key_pair_name

  user_data = file("minecraft_setup.sh")

  tags = {
    Name = "MinecraftServer"
  }

  # Attach the EBS Volume
  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }

  ebs_block_device {
    device_name           = "/dev/xvdf"
    volume_id             = aws_ebs_volume.minecraft_volume.id
    delete_on_termination = false
  }
}