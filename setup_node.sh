#!/bin/bash

# Update and upgrade system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Python and dependencies
sudo apt-get install python -y
sudo apt-get install python3-pip -y
sudo apt-get install python3-tk python3-dev -y
pip install undetected-chromedriver
pip install selenium

# Install additional packages
sudo apt-get install sshpass -y
sudo apt-get install default-jdk -y
sudo apt-get install unzip -y

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install -y

# Download and install Chromedriver
cd /home
wget https://storage.googleapis.com/chrome-for-testing-public/121.0.6167.85/linux64/chromedriver-linux64.zip
unzip chromedriver-linux64.zip
sudo mv /home/chromedriver-linux64/chromedriver /usr/local/bin/

# Download and configure Selenium Server
wget https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.8.0/selenium-server-4.8.0.jar

# Create systemd service for Selenium Grid
sudo tee /etc/systemd/system/selenium-grid.service > /dev/null <<EOL
[Unit]
Description=Selenium Grid
After=network.target

[Service]
User=root
WorkingDirectory=/home
ExecStart=/usr/bin/java -jar selenium-server-4.8.0.jar node --hub http://45.13.59.173:4444 --max-sessions 35 --override-max-sessions true --session-timeout 21600
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Enable and start Selenium Grid service
sudo systemctl enable selenium-grid.service
sudo systemctl start selenium-grid.service
sudo systemctl restart selenium-grid.service

echo "Setup completed successfully."