#!/bin/bash
# Install CloudWatch Agent
yum update -y
yum install -y amazon-cloudwatch-agent

# Create the CloudWatch Agent configuration file
cat <<EOL > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/minecraft/server",
            "log_stream_name": "{instance_id}/messages",
            "timestamp_format": "%b %d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOL

# Start the CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s


# Update packages and install Java
amazon-linux-extras enable java-openjdk11
yum install -y java-11-openjdk

# Mount the EBS Volume
mkfs.ext4 /dev/xvdf
mkdir -p /opt/minecraft
mount /dev/xvdf /opt/minecraft

# Persist the mount in fstab
echo "/dev/xvdf /opt/minecraft ext4 defaults,nofail 0 2" >> /etc/fstab

# Download Minecraft server JAR
cd /opt/minecraft
curl -o server.jar https://launcher.mojang.com/v1/objects/5f6edc5cb3decd6783fb9dfdfd27bc192a97aa89/server.jar

# Agree to Minecraft EULA
echo "eula=true" > eula.txt

# Create a systemd service for Minecraft
cat <<EOL > /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=root
WorkingDirectory=/opt/minecraft
ExecStart=/usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

# Enable and start the Minecraft service
systemctl enable minecraft
