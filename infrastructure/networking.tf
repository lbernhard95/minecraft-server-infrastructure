/*resource "aws_eip" "minecraft_eip" {
  instance = aws_instance.minecraft_instance.id
}

data "aws_route53_zone" "zone"{
  name = var.route53_zone_id
}
resource "aws_route53_record" "minecraft_dns" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "minecraft.${var.route53_zone_id}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.minecraft_eip.public_ip]
}

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft_sg"
  description = "Allow Minecraft traffic"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}*/