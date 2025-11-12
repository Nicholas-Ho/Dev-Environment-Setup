#!/bin/bash

# Setup script for personal workspace on Ubuntu


# === Vim setup ===

# Setup symlink to .vimrc. Assumes .vimrc source is in a ./vim directory relative to this script.
src_dir=$(dirname $(realpath "$0"))
vimrc_src="${src_dir}/vim/.vimrc"
ln -s ${vimrc_src} ~/.vimrc

# Copy plugin files to ~/.vim/plugin
plugin_src="${src_dir}/vim/plugin"
mkdir -p ~/.vim/plugin
cp -r ${plugin_src} ~/.vim/plugin

# Install plugins
vim -E -s -u ~/.vimrc +'PlugInstall --sync' +qa


# === Installing packages ===

og_dir=$(pwd)

# Make a temporary directory for installations
tmp_dir=~/.tmpdir
mkdir -p ${tmp_dir}
cd ${tmp_dir}

# Cleanup temporary directory on exit
function cleanup {
    cd ${og_dir}
    rm -rf ${tmp_dir}
}
trap cleanup EXIT

# ripgrep
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb
sudo dpkg -i ripgrep_14.1.1-1_amd64.deb

# bat
curl -LO https://github.com/sharkdp/bat/releases/download/v0.26.0/bat_0.26.0_amd64.deb
sudo dpkg -i bat_0.26.0_amd64.deb

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

# code-minimap
curl -LO https://github.com/wfxr/code-minimap/releases/download/v0.6.8/code-minimap_0.6.8_amd64.deb
sudo dpkg -i code-minimap_0.6.8_amd64.deb


# === Install language servers ===

sudo apt update

# Ensure that all necessary package managers are installed
sudo apt install -y python3-pip # pip3
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash # nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install node # node and npm

# Python. Must install pip3 first
pip3 install -U python-lsp-server

# C/C++
sudo apt install -y clangd-12
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100

# Bash. Must install npm first
sudo apt install shellcheck
npm install -g bash-language-server

# Vim. Must install npm first
npm install -g vim-language-server

# YAML. Must install npm first
npm install -g yaml-language-server

# Haskell language server is bundled in its installation and should be installed when required

cd ${og_dir}


# === Additional setup ===

# bat. Load themes into cache
mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
cp $src_dir/bat/themes/* "$(bat --config-dir)/themes"
bat cache --build


# === Shell setup ===

# Add to .bashrc. Assumes shellrc.sh source is in a ./bash directory relative to this script.Assumes .vimrc source is in a ./vim directory relative to this script.
shellrc_src="${src_dir}/bash/shellrc.sh"
echo -e "\n# Personal shell setup\nsource ${shellrc_src}" >> ~/.bashrc

# Prompt the user to run .bashrc for final setup
echo -e "\n\n\n=== Setup complete! ===\nRestart the terminal or run the following command to start using\n\nsource ~/.bashrc"
