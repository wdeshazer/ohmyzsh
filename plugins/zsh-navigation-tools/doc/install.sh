#!/bin/sh

local XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

if ! type git 2>/dev/null 1>&2; then
    echo "Please install GIT first"
    echo "Exiting"
    exit 1
fi

#
# Clone or pull
#

if ! test -d "${XDG_CONFIG_HOME}"; then
    mkdir "${XDG_CONFIG_HOME}"
fi

if ! test -d "${XDG_CONFIG_HOME}/znt"; then
    mkdir "${XDG_CONFIG_HOME}/znt"
fi

echo ">>> Downloading zsh-navigation-tools to ${XDG_CONFIG_HOME}/znt"
if test -d ${XDG_CONFIG_HOME}/znt/zsh-navigation-tools; then
    cd ${XDG_CONFIG_HOME}/znt/zsh-navigation-tools
    git pull origin master
else
    cd ${XDG_CONFIG_HOME}/znt
    git clone https://github.com/psprint/zsh-navigation-tools.git zsh-navigation-tools
fi
echo ">>> Done"

#
# Copy configs
#

echo ">>> Copying config files"

cd ${XDG_CONFIG_HOME}/znt

set n-aliases.conf n-env.conf n-history.conf n-list.conf n-panelize.conf n-cd.conf n-functions.conf n-kill.conf n-options.conf

for i; do
    if ! test -f "$i"; then
        cp -v zsh-navigation-tools/.config/znt/$i .
    fi
done

echo ">>> Done"

#
# Modify ${ZDOTDIR}/.zshrc
#

echo ">>> Updating ${ZDOTDIR}/.zshrc"
if ! grep zsh-navigation-tools ${ZDOTDIR}/.zshrc >/dev/null 2>&1; then
    echo >> ${ZDOTDIR}/.zshrc
    echo "### ZNT's installer added snippet ###" >> ${ZDOTDIR}/.zshrc
    echo "fpath=( \"\$fpath[@]\" \"\${XDG_CONFIG_HOME}/znt/zsh-navigation-tools\" )" >> ${ZDOTDIR}/.zshrc
    echo "autoload n-aliases n-cd n-env n-functions n-history n-kill n-list n-list-draw n-list-input n-options n-panelize n-help" >> ${ZDOTDIR}/.zshrc
    echo "autoload znt-usetty-wrapper znt-history-widget znt-cd-widget znt-kill-widget" >> ${ZDOTDIR}/.zshrc
    echo "alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history" >> ${ZDOTDIR}/.zshrc
    echo "alias nkill=n-kill noptions=n-options npanelize=n-panelize nhelp=n-help" >> ${ZDOTDIR}/.zshrc
    echo "zle -N znt-history-widget" >> ${ZDOTDIR}/.zshrc
    echo "bindkey '^R' znt-history-widget" >> ${ZDOTDIR}/.zshrc
    echo "setopt AUTO_PUSHD HIST_IGNORE_DUPS PUSHD_IGNORE_DUPS" >> ${ZDOTDIR}/.zshrc
    echo "zstyle ':completion::complete:n-kill::bits' matcher 'r:|=** l:|=*'" >> ${ZDOTDIR}/.zshrc
    echo "### END ###" >> ${ZDOTDIR}/.zshrc
    echo ">>> Done"
else
    echo ">>> ${ZDOTDIR}/.zshrc already updated, not making changes"
fi
