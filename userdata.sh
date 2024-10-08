#!/bin/bash

# Log output to a file for debugging
exec > /tmp/userdata.log 2>&1

# Update and install dependencies
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl gnupg2 software-properties-common

# Install Java 17
sudo apt install -y openjdk-17-jdk

# Verify Java installation
java -version

# Add Jenkins GPG key and repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list and install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# Start and enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Allow Jenkins through the firewall (port 8080)
sudo ufw allow 8080
sudo ufw allow OpenSSH
sudo ufw enable -y

# Print a success message to the log
echo "Jenkins installation completed"
