variable "route53_zone_id" {
  description = "Route53 Zone ID for lukas-bernhard.de"
  default = "lukas-bernhard.de"
}

variable "key_pair_name" {
  description = "Key pair name for SSH access"
  default = "minecraft-server"
}
