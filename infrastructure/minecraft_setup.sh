#!/bin/bash
# Update packages and install Java
yum update -y
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
