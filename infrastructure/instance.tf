resource "aws_instance" "minecraft_instance" {
  ami           = "ami-08c40ec9ead489470" # Amazon Linux 2 AMI
  instance_type = "t4g.medium"
  security_groups = [aws_security_group.minecraft_sg.name]
  key_name      = var.key_pair_name

  user_data = file("minecraft_setup.sh")
}

resource "aws_ebs_volume" "minecraft_volume" {
  availability_zone = "eu-central-1a" # Match your instance's AZ
  size              = 10           # 10GB storage
}


resource "aws_volume_attachment" "minecraft_attachment" {
  device_name = "/dev/xvdf" # Device name for mounting
  volume_id   = aws_ebs_volume.minecraft_volume.id
  instance_id = aws_instance.minecraft_instance.id
}