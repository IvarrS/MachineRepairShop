!/bin/bash

sudo apt-get install opennebula-tools
sudo apt update
sudo apt install -y python3 python3-pip git
sudo pip3 install ansible pyone
sudo apt install gnupg

set -e

echo "checking if ansible is already installed..."

if command -v ansible &> /dev/null; then
	echo "Ansible is already installed."
	echo "Current version is:"
	ansible --version
	exit 
fi

if command -v apt-get &> /dev/null; then
	echo "INFO: Detected Devian/Ubuntu based system."
	echo "INFO: Updating package list..."
	sudo apt-get update -y
	echo "Installed ansible..."
	sudo apt-get install ansible -y
else
	echo "ERROR: Install ansible manually."
	exit 1
fi

echo "INFO: Verifying ansible installation..."

if command -v ansible &> /dev/null; then
	echo "Ansible was installed successfully"
	echo "Ansible version:"
	ansible --version
	exit 0
else
	echo "Error: ansible did not install"
	exit 1
fi
