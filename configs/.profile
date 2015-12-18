echo "read ~/.profile (iterm)" >&2 | grep iterm --color=auto

if [ -f ~/.bashrc ] ;then
    echo "     ~/.profile: source ~/.bashrc"
    source ~/.bashrc
fi