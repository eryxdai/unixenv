echo "read ~/.bash_profile (terminal or on Linux)" >&2 | grep "(.*)" --color=auto

if [ -f ~/.bashrc ] ;then
    echo "     ~/.bash_profile: source ~/.bashrc"
    source ~/.bashrc
fi
