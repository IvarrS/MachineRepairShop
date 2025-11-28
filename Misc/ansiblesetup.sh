#!/bin/bash

sudo apt-get update
sudo apt install gnupg -y
wget -q -O- https://downloads.opennebula.org/repo/repo.key | sudo apt-key add -
echo "deb https://downloads.opennebula.org/repo/5.6/Ubuntu/18.04 stable opennebula" | sudo tee /etc/apt/sources.list.d/opennebula.list
sudo apt-get install opennebula-tools -y
sudo apt install git -y
pip install pyone
sudo apt install ansible -y
ansible-galaxy collection install community.general
sudo apt-get install -y sshpass

set -e

echo "Updating package list..."
sudo apt-get update -y

echo "Installing required system packages..."
sudo apt-get install -y \
    ansible \
    python3 \
    python3-venv \
    python3-pip

VENV_PATH="$HOME/.ansible-venv"

if [ ! -d "$VENV_PATH" ]; then
    echo "Creating Python virtual environment at $VENV_PATH"
    python3 -m venv "$VENV_PATH"
else
    echo "Virtual environment already exists at $VENV_PATH"
fi

echo "Activating virtual environment..."
source "$VENV_PATH/bin/activate"

echo "Installing pyone in virtual environment..."
pip install pyone
pip3 install pexpect

echo "Installing Ansible OpenNebula collection..."
ansible-galaxy collection install community.general

echo "=== Installing pyone inside virtual environment ==="
pip install --upgrade pip
pip install pyone

echo "=== Installing Ansible OpenNebula collection ==="
ansible-galaxy collection install community.general

echo "=== Installing opennebula-tools ==="
sudo apt-get install -y opennebula-tools

echo "=== Cloning MachineRepairShop repo ==="
if [ ! -d "$HOME/MachineRepairShop" ]; then
    git clone https://github.com/IvarrS/MachineRepairShop.git "$HOME/MachineRepairShop"
else
    echo "Repository already exists at $HOME/MachineRepairShop"
fi

cd MachineRepairShop/Ansible

ansible-playbook main.yml -i inv.ini --vault-password-file password
