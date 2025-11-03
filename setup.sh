#!/bin/bash

# Setup script for personal workspace on Ubuntu


# Parse flags
for opt in "$@"; do
    case $opt in
        --no-root) no_root=1 ;;
        *)
            echo "Unknown option: $opt"
            exit 1
            ;;
    esac
done


# === Vim setup ===

# Setup symlink to .vimrc. Assumes .vimrc source is in a ./vim directory relative to this script.
src_dir=$(dirname "$(realpath "$0")")
vimrc_src="${src_dir}/vim/.vimrc"
ln -s ${vimrc_src} ~/.vimrc

# Copy autoload files to ~/.vim/autoload
autoload_src="${src_dir}/vim/autoload"
mkdir -p ~/.vim/autoload
cp -r ${autoload_src} ~/.vim/autoload

# Install plugins
vim -E -s -u ~/.vimrc +'PlugInstall --sync' +qa


# === Installing packages ===

og_dir=$(pwd)

# Make a temporary directory for installations
tmp_dir=~/.tmpdir
mkdir -p ${tmp_dir}
cd "${tmp_dir}"

# Cleanup temporary directory on exit
function cleanup {
    cd "${og_dir}"
    rm -rf ${tmp_dir}
}
trap cleanup EXIT

# Setup function to install .deb packages
function install_deb() {
    if [[ -n "${no_root}" ]] && [[ ${no_root} == 1 ]]; then
        dpkg -x $1 x_dir
        mkdir -p ~/.local/bin
        cp $(realpath "$(find x_dir -type d -name 'bin')")/* ~/.local/bin
    else
        sudo dpkg -i "$1"
    fi
}

function install_apt() {
    if [[ -n "${no_root}" ]] && [[ ${no_root} == 1 ]]; then
        apt-get download "$1"
        install_deb "$(find $1*)"
    else
        sudo apt install -y "$1"
    fi
}

# ripgrep
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb
install_deb ripgrep_14.1.1-1_amd64.deb

# bat
curl -LO https://github.com/sharkdp/bat/releases/download/v0.26.0/bat_0.26.0_amd64.deb
install_deb bat_0.26.0_amd64.deb

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc

# code-minimap
curl -LO https://github.com/wfxr/code-minimap/releases/download/v0.6.8/code-minimap_0.6.8_amd64.deb
install_deb code-minimap_0.6.8_amd64.deb


# === Install language servers ===

# Ensure that all necessary package managers are installed
sudo apt install -y python3-pip # pip3
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash # nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install node # node and npm

# Python. Must install pip3 first
pip3 install -U python-lsp-server

# C/C++
install_apt unzip # first install unzip
curl -LO https://github.com/clangd/clangd/releases/download/21.1.0/clangd-linux-21.1.0.zip
unzip clangd-linux-21.1.0.zip
install_deb clangd_21.1.0
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100

# Bash. Must install npm first
sudo apt install -y shellcheck
npm install -g bash-language-server

# Vim. Must install npm first
npm install -g vim-language-server

# YAML. Must install npm first
npm install -g yaml-language-server

cd "${og_dir}"


# === Shell setup ===

# Add to .bashrc. Assumes shellrc.sh source is in a ./bash directory relative to this script.Assumes .vimrc source is in a ./vim directory relative to this script.
shellrc_src="${src_dir}/bash/shellrc.sh"
echo -e "\n# Personal shell setup\nsource ${shellrc_src}" >> ~/.bashrc

# Prompt the user to run .bashrc for final setup
echo -e "\n\n\n=== Setup complete! ===\nRestart the terminal or run the following command to start using\n\nsource ~/.bashrc"
