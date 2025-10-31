#!/bin/bash

# Setup script for personal workspace on Ubuntu


# === Vim setup ===

# Setup symlink to .vimrc. Assumes .vimrc source is in a ./vim directory relative to this script.
src_dir=$(dirname $(realpath "$0"))
vimrc_src="${src_dir}/vim/.vimrc"
ln -s ${vimrc_src} ~/.vimrc

# Copy autoload files to ~/.vim/autoload
autoload_src="${src_dir}/vim/autoload"
mkdir -p ~/.vim/autoload
cp -r ${autoload_src} ~/.vim/autoload


# === Installing packages ===

og_dir=$(pwd)

# Make a temporary directory for installations
tmp_dir=~/.tmpdir
mkdir ${tmp_dir}
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
~/.fzf/install

# code-minimap
curl -LO https://github.com/wfxr/code-minimap/releases/download/v0.6.8/code-minimap_0.6.8_amd64.deb
sudo dpkg -i code-minimap_0.6.8_amd64.deb

cd ${og_dir}


# === Shell setup ===

# Add to .bashrc. Assumes shellrc.sh source is in a ./bash directory relative to this script.Assumes .vimrc source is in a ./vim directory relative to this script.
shellrc_src="${src_dir}/bash/shellrc.sh"
echo -e "\n# Personal shell setup\nsource ${shellrc_src}" >> ~/.bashrc
