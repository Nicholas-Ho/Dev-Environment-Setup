#!/bin/bash

if ! command -v python3 >/dev/null 2>&1; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
        sudo apt update
        sudo apt install -y python3 python3-venv python3-pip
    elif [[ "$ID" == "arch" ]]; then
        sudo pacman -S python python-pip
    fi
fi

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

# Guard against PATH issues
export PATH="$HOME/.local/bin:$PATH"

python3 -m pip install --upgrade pip
python3 -m pip install ansible
ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml -K -u "$(whoami)"

deactivate
