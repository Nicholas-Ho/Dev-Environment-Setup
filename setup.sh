#!/bin/bash

sudo apt update
sudo apt install -y python3 python3-venv python3-pip

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

python3 -m pip install --upgrade pip
python3 -m pip install ansible
ansible-playbook -i inventory.ini playbook.yaml
