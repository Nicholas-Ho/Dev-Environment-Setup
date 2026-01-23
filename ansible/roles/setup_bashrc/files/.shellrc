#!/bin/bash

# === A setup script to be called in .bashrc or equivalent ===

# Add ~/.local/bin to PATH (required for some user-level installations such as pylsp)
usr_bin="$HOME/.local/bin"
if [ -d "${usr_bin}" ] && [[ ":$PATH:" != *":${usr_bin}:"* ]]; then
    PATH="${PATH:+"$PATH:"}${usr_bin}"
fi

# fzf setup
[ -f ~/.fzf.bash ] && source ~/.fzf.bash # Usually in .bashrc, moved here to keep fzf setup together
export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git/'"
complete -o bashdefault -o default -F _fzf_path_completion vim

# Additional environment variables
# export BASH_IDE_LOG_LEVEL=error # for bash-language-server
export BACKGROUND_ANALYSIS_MAX_FILES=0 # for bash-language-server

# Override prompt
format_git_prompt() {
    git_curr_branch=$(git branch --show-current 2>/dev/null)
    git_modified_count='-'
    git_ahead_count='-'
    git_behind_count='-'
    if [[ ${git_curr_branch} == "" ]]; then
        git_curr_branch="none"
    else
        git fetch > /dev/null 2>&1 &
        git_modified_tracked_count=$(git status -s -uno | wc -l)
        git_untracked_count=$(git ls-files --others --exclude-standard | wc -l)
        git_modified_count=$((${git_modified_tracked_count}+${git_untracked_count}))
        # Error handling to handle no upstream
        git_ahead_count=$(git rev-list ${git_curr_branch} --not origin/${git_curr_branch} --count 2>/dev/null || echo '-')
        git_behind_count=$(git rev-list origin/${git_curr_branch} --not ${git_curr_branch} --count 2>/dev/null || echo '-')
    fi
    echo -e "\e[93m ${git_curr_branch} \e[01;34m󰓦 ${git_modified_count} \e[01;32m ${git_ahead_count} \e[31m ${git_behind_count} "
}
PROMPT_COMMAND='GIT_PROMPT=$(format_git_prompt)'
PS1='\[\[\e[32m\[\A \e[34m\[\w ${GIT_PROMPT}\[\e[0m\[\n󰘍 \$ '
