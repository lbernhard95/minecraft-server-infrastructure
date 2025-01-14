resource "aws_instance" "minecraft_instance" {
  ami           = "ami-073636b61345c967f" # Amazon Linux 2 AMI
  instance_type = "t4g.medium"
  security_groups = [aws_security_group.minecraft_sg.name]

  user_data = file("minecraft_setup.sh")
}

resource "aws_ebs_volume" "minecraft_volume" {
  availability_zone = aws_instance.minecraft_instance.availability_zone
  size              = 10           # 10GB storage
}


resource "aws_volume_attachment" "minecraft_attachment" {
  device_name = "/dev/xvdf" # Device name for mounting
  volume_id   = aws_ebs_volume.minecraft_volume.id
  instance_id = aws_instance.minecraft_instance.id
}